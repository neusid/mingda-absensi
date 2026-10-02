import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Menampilkan gambar dari jaringan dengan dukungan Cloudflare R2 dan validasi byte stream.
///
/// Cloudflare R2 (`*.r2.dev`) terkadang memiliki masalah sertifikat SSL
/// (hostname mismatch) sehingga `NetworkImage` standar gagal dimuat.
/// Widget ini memakai [HttpClient] khusus untuk host `r2.dev`, memverifikasi
/// integritas magic bytes gambar sebelum diteruskan ke native decoder, dan
/// langsung menampilkan fallback bila URL kosong atau tidak valid untuk
/// mencegah error `ImageDecoder$DecodeException: unimplemented`.
class ProfileNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final Widget? fallback;

  const ProfileNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 10,
    this.fit = BoxFit.cover,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = url.trim();

    if (cleanUrl.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          cleanUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stack) {
            return fallback ?? _buildDefaultFallback();
          },
        ),
      );
    }

    if (cleanUrl.isEmpty ||
        (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://'))) {
      return fallback ?? _buildDefaultFallback();
    }

    final imageProvider = _InsecureR2NetworkImage(cleanUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stack) {
          return fallback ?? _buildDefaultFallback();
        },
      ),
    );
  }

  Widget _buildDefaultFallback() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: (width ?? 50) * 0.6,
        color: Colors.grey,
      ),
    );
  }
}

class _InsecureR2NetworkImage extends ImageProvider<_InsecureR2NetworkImage> {
  final String url;

  _InsecureR2NetworkImage(this.url);

  @override
  Future<_InsecureR2NetworkImage> obtainKey(
    ImageConfiguration configuration,
  ) async {
    return this;
  }

  @override
  ImageStreamCompleter loadImage(
    _InsecureR2NetworkImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  static bool _isValidImageBytes(Uint8List bytes) {
    if (bytes.length < 12) return false;
    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }
    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return true;
    }
    // GIF: GIF8
    if (bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x38) {
      return true;
    }
    // WebP: RIFF .... WEBP
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return true;
    }
    // BMP: BM
    if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
      return true;
    }
    return false;
  }

  Future<ui.Codec> _loadAsync(
    _InsecureR2NetworkImage key,
    ImageDecoderCallback decode,
  ) async {
    final client = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        return host.endsWith('.r2.dev') || host == 'r2.dev';
      };

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        throw const FormatException('Invalid image URI');
      }

      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'HTTP ${response.statusCode} loading $url',
          uri: uri,
        );
      }
      final bytes = await consolidateHttpClientResponseBytes(response);
      if (!_isValidImageBytes(bytes)) {
        throw FormatException(
          'Response bytes from $url are not a supported image format',
        );
      }
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return await decode(buffer);
    } finally {
      client.close();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _InsecureR2NetworkImage && other.url == url;

  @override
  int get hashCode => url.hashCode;
}

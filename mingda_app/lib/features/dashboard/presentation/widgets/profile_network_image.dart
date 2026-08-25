import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// Menampilkan gambar profil dari jaringan.
///
/// Cloudflare R2 (`*.r2.dev`) terkadang punya masalah sertifikat SSL
/// (hostname mismatch) sehingga `NetworkImage` biasa gagal dimuat.
/// Widget ini memakai [HttpClient] custom yang hanya menerima sertifikat
/// untuk host `r2.dev`, supaya gambar profil tetap tampil tanpa
/// memengaruhi verifikasi SSL untuk domain lain.
class ProfileNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;

  const ProfileNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 10,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = _InsecureR2NetworkImage(url);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stack) {
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
        },
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

  Future<ui.Codec> _loadAsync(
    _InsecureR2NetworkImage key,
    ImageDecoderCallback decode,
  ) async {
    final client = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        return host.endsWith('.r2.dev') || host == 'r2.dev';
      };

    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'HTTP ${response.statusCode} loading $url',
          uri: Uri.parse(url),
        );
      }
      final bytes = await consolidateHttpClientResponseBytes(response);
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

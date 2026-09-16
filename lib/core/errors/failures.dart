abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

// Tidak ada koneksi internet
class NetworkFailure extends Failure {
  const NetworkFailure() : super('Tidak ada koneksi internet');
}

// Response server error (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Cache/lokal tidak ditemukan atau rusak
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Input user tidak valid (sebelum sampai ke server)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Token tidak ada atau sudah expired
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Timeout — server terlalu lama merespons
class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Koneksi timeout, coba lagi');
}

// SharedPreferences gagal baca data — key tidak ditemukan
class StorageNotFoundFailure extends Failure {
  const StorageNotFoundFailure(super.message);
}

// SharedPreferences gagal tulis atau hapus data
class StorageWriteFailure extends Failure {
  const StorageWriteFailure(super.message);
}

class AppConfig {
  /// Mode offline global aplikasi:
  /// Ketika bernilai `false`, fitur-fitur aplikasi berjalan menggunakan Real API backend (live).
  static const bool isOfflineMode = false;

  /// Mode mock khusus fitur Work Leave:
  /// Diaktifkan sementara (mock data) karena backend cuti sedang bermasalah.
  /// Fitur selain work leave tetap menggunakan Real API.
  static const bool isWorkLeaveMockMode = true;
}

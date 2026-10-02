class AppConfig {
  /// Mode offline global aplikasi:
  /// Ketika bernilai `true`, fitur-fitur aplikasi berjalan menggunakan Mock Data Source (offline 100%).
  /// Ketika bernilai `false`, fitur-fitur aplikasi berjalan menggunakan Real API backend (live).
  static const bool isOfflineMode = true;

  /// Mode mock khusus fitur Work Leave:
  /// Diaktifkan sementara (mock data) karena backend cuti sedang bermasalah.
  /// Fitur selain work leave tetap menggunakan Real API.
  static const bool isWorkLeaveMockMode = true;
}

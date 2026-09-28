import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source.dart';

class SplashDummyDataSourceImpl implements SplashRemoteDataSource {
  @override
  Future<void> CheckToken(String token) async {
    // Simulasi delay singkat agar animasi splash berjalan mulus
    await Future.delayed(const Duration(milliseconds: 400));
    return;
  }
}

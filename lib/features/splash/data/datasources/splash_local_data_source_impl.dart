import 'package:mingda_app/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl({required this.sharedPreferences});

  Future<String?> getToken() async {
    final result = await sharedPreferences.getString('token');
    return result;
  }
}

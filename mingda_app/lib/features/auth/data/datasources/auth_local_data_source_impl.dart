import 'dart:convert';

import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mingda_app/features/auth/data/models/auth_session_model.dart';
import 'package:mingda_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  Future<void> saveRemember(AuthSessionModel model) async {
    final String stringSession = jsonEncode(model.toJson());
    await sharedPreferences.setString('remember', stringSession);
  }

  Future<AuthSessionModel> getRemember() async {
    final result = await sharedPreferences.getString('remember');
    return AuthSessionModel.fromJson(jsonDecode(result!));
  }

  Future<void> removeSession() async {
    await sharedPreferences.remove('remember');
  }

  Future<String?> getToken() async {
    final result = await sharedPreferences.getString('token');
    return result;
  }

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('token', token);
  }

  Future<void> deleteToken() async {
    await sharedPreferences.remove('token');
  }

  Future<void> saveUser(UserModel user) async {
    String userData = user.toString();
    await sharedPreferences.setString('user', userData);
  }

  Future<void> deleteUser() async {
    await sharedPreferences.remove('user');
  }
}

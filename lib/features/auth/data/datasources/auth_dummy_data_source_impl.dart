import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/models/login_model.dart';
import 'package:mingda_app/features/auth/data/models/user_model.dart';

class AuthDummyDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<LoginModel> SignInDataSource({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return LoginModel(
      success: true,
      messages: 'Login berhasil (Offline Mode)',
      tokenType: 'Bearer',
      token: 'dummy_offline_token_mingda_2026',
      userModel: UserModel(
        id: 1,
        name: email.isNotEmpty && email.contains('@')
            ? email.split('@').first.replaceAll('.', ' ').toUpperCase()
            : 'Malik Ibrahim',
        email: email.isNotEmpty ? email : 'admin@mingda.co.id',
        role: 'Employee',
      ),
    );
  }

  @override
  Future<void> SignOutDataSource(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> CheckToken(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<String> forgotPasswordDataSource({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'Tautan instruksi pemulihan kata sandi telah dikirim ke $email.';
  }
}

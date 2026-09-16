import 'package:mingda_app/features/auth/data/models/user_model.dart';

class LoginEntity {
  final String token;
  final UserModel userModel;

  const LoginEntity({required this.token, required this.userModel});
}

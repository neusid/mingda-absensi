import 'package:mingda_app/features/auth/data/models/user_model.dart';
import 'package:mingda_app/features/auth/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  final bool success;
  final String messages;
  final String tokenType;

  const LoginModel({
    required this.success,
    required this.messages,
    required this.tokenType,
    required super.token,
    required super.userModel,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final dataFields = json['data'] as Map<String, dynamic>;

    return LoginModel(
      success: json['success'] as bool,
      messages: json['message'],
      tokenType: dataFields['token_type'] as String,
      token: dataFields['token'] as String,
      userModel: UserModel.fromJson(dataFields['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'messages': messages,
      'tokenType': tokenType,
      'token': token,
      'userModel': userModel,
    };
  }
}

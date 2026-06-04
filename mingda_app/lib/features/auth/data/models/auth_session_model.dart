import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({
    required String email,
    required String? password,
    required bool isChecked,
  }) : super(email: email, password: password, isChecked: isChecked);

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      isChecked: json['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'isChecked': isChecked};
  }

  factory AuthSessionModel.fromEntity(AuthSessionEntity entity) {
    return AuthSessionModel(
      email: entity.email,
      password: entity.password,
      isChecked: entity.isChecked,
    );
  }
}

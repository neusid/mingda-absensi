class AuthSessionEntity {
  final String email;
  final String? password;
  final bool isChecked;

  const AuthSessionEntity({
    required this.email,
    required this.password,
    required this.isChecked,
  });
}

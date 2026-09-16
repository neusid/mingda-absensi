part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final AuthSessionEntity authSessionEntity;

  LoginSubmitted({required this.authSessionEntity});
}

class LogoutRequested extends AuthEvent {}

import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Login berhasil
class AuthAuthenticated extends AuthState {}

// Belum login / token expired
class AuthUnauthenticated extends AuthState {}

class AuthRememberDataLoaded extends AuthState {
  final bool? isCheck;

  AuthRememberDataLoaded(this.isCheck);
}

class AuthSessionDataSaved extends AuthState {
  final AuthSessionEntity entity;

  AuthSessionDataSaved(this.entity);
}

class AuthSessionDataRemoved extends AuthState {
  final AuthSessionEntity entity;

  AuthSessionDataRemoved(this.entity);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

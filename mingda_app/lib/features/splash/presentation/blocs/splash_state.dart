part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialSplashState extends SplashState {}

class LoadingSplashState extends SplashState {}

class SuccessSplashState extends SplashState {
  final String value;

  SuccessSplashState(this.value);
}

class LoadedSplashState extends SplashState {
  final AuthSessionEntity authSessionEntity;

  LoadedSplashState(this.authSessionEntity);
}

class NotLoadedSplashState extends SplashState {}

class FailureSplashState extends SplashState {}

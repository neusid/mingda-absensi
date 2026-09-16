part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AppStarted extends SplashEvent {}

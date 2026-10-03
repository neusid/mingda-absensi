part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {}

class DashboardSignout extends DashboardEvent {}

class DashboardUpdateProfile extends DashboardEvent {
  final ProfileEntity profile;
  final void Function(ProfileEntity updatedProfile)? onSuccess;
  final void Function(String errorMessage)? onError;

  const DashboardUpdateProfile({
    required this.profile,
    this.onSuccess,
    this.onError,
  });

  @override
  List<Object?> get props => [profile];
}

class DashboardChangePassword extends DashboardEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final void Function()? onSuccess;
  final void Function(String errorMessage)? onError;

  const DashboardChangePassword({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    this.onSuccess,
    this.onError,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

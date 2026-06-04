part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialDashboardState extends DashboardState {}

class LoadingDashboardState extends DashboardState {}

class SuccessDashboardState extends DashboardState {
  final bool value;

  SuccessDashboardState(this.value);
}

class SignoutDashboardState extends DashboardState {}

class FailureDashboardState extends DashboardState {}

part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {}

class DashboardSignout extends DashboardEvent {}

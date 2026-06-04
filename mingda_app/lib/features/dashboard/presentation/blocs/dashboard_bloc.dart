import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SignoutUsecase signoutUsecase;

  DashboardBloc({required this.signoutUsecase})
    : super(InitialDashboardState()) {
    on<DashboardStarted>((event, emit) {
      // TODO: implement event handler
    });

    on<DashboardSignout>((event, emit) async {
      emit(LoadingDashboardState());
      final result = await signoutUsecase();
      result.fold(
        (l) => emit(FailureDashboardState()),
        (r) => emit(SignoutDashboardState()),
      );
    });
  }
}

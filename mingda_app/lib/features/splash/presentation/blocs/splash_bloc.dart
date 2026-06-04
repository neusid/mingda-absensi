import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/usecases/get_remember_usecase.dart';
import 'package:mingda_app/features/splash/domain/usecases/gettoken_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GettokenUsecase getTokenUsecase;
  final GetRememberUsecase getRememberUsecase;

  SplashBloc({required this.getTokenUsecase, required this.getRememberUsecase})
    : super(InitialSplashState()) {
    on<AppStarted>((event, emit) async {
      // TODO: implement event handler
      emit(LoadingSplashState());
      final result = await getTokenUsecase();
      final rememberValue = await getRememberUsecase();
      result.fold((l) => emit(FailureSplashState()), (r) {
        rememberValue.fold(
          (l) => emit(FailureSplashState()),
          (r) => emit(SuccessSplashState(r!)),
        );
      });
    });
  }
}

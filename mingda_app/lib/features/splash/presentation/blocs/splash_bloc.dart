import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
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

      await result.fold(
        (l) async {
          emit(FailureSplashState());
        },
        (r) async {
          if (r == null || r.isEmpty) {
            emit(FailureSplashState());
            return;
          }
          emit(SuccessSplashState(r));
        },
      );
    });
  }
}

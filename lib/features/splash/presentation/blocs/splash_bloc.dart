import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/domain/usecases/get_remember_usecase.dart';
import 'package:mingda_app/features/splash/domain/usecases/checktoken_usecase.dart';
import 'package:mingda_app/features/splash/domain/usecases/gettoken_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GettokenUsecase getTokenUsecase;
  final GetRememberUsecase getRememberUsecase;
  final CheckTokenUsecase checkTokenUsecase;

  SplashBloc({
    required this.getTokenUsecase,
    required this.getRememberUsecase,
    required this.checkTokenUsecase,
  }) : super(InitialSplashState()) {
    on<AppStarted>((event, emit) async {
      emit(LoadingSplashState());

      final result = await getTokenUsecase();

      await result.fold(
        (l) async {
          emit(FailureSplashState());
        },
        (token) async {
          if (token.isEmpty) {
            emit(FailureSplashState());
            return;
          }

          final checkResult = await checkTokenUsecase(token);

          await checkResult.fold(
            (l) async {
              // Token expired / tidak valid -> minta login ulang
              emit(FailureSplashState());
            },
            (_) async {
              emit(SuccessSplashState(token));
            },
          );
        },
      );
    });
  }
}

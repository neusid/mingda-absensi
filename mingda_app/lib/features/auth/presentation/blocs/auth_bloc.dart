import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/domain/usecases/get_remember_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/remove_auth_session_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/save_remember_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/savetoken_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SigninUsecase signinUsecase;
  final GetRememberUsecase getRememberUsecase;
  final SaveRememberUsecase saveRememberUsecase;
  final RemoveAuthSessionUsecase removeAuthSessionUsecase;
  final SavetokenUsecase savetokenUsecase;

  AuthBloc({
    required this.signinUsecase,
    required this.getRememberUsecase,
    required this.saveRememberUsecase,
    required this.removeAuthSessionUsecase,
    required this.savetokenUsecase,
  }) : super(AuthInitial()) {
    on<AuthStarted>((event, emit) async {
      emit(AuthLoading());

      final result = await getRememberUsecase();

      result.fold(
        (l) => emit(AuthError(l.toString())),
        (r) => emit(AuthRememberDataLoaded(r.isChecked)),
      );
    });

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());

      final result = await signinUsecase(
        LoginParams(
          email: event.authSessionEntity.email,
          password: event.authSessionEntity.password!,
        ),
      );

      await result.fold(
        // l
        (failure) async => emit(AuthError(failure.toString())),
        // r
        (login) async {
          if (event.authSessionEntity.isChecked) {
            final save = await saveRememberUsecase(event.authSessionEntity);
            save.fold(
              (l) => emit(AuthError(l.message)),
              (r) => emit(AuthAuthenticated()),
            );
          } else {
            final remove = await removeAuthSessionUsecase();
            remove.fold(
              (l) => emit(AuthError(l.message)),
              (r) => emit(AuthAuthenticated()),
            );
          }
        },
      );
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/bloc/language_event.dart';
import 'package:mingda_app/core/localization/bloc/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String prefKey = 'mingda_selected_language';
  final SharedPreferences? sharedPreferences;

  LanguageBloc({
    this.sharedPreferences,
    AppLanguage initialLanguage = AppLanguage.id,
  }) : super(LanguageState(language: initialLanguage)) {
    on<LoadLanguageEvent>(_onLoadLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  void _onLoadLanguage(
    LoadLanguageEvent event,
    Emitter<LanguageState> emit,
  ) {
    final savedCode = sharedPreferences?.getString(prefKey);
    final language = AppLanguage.fromCode(savedCode);
    emit(LanguageState(language: language));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    emit(LanguageState(language: event.language));
    await sharedPreferences?.setString(prefKey, event.language.code);
  }
}

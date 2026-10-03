import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/localization/app_language.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LoadLanguageEvent extends LanguageEvent {
  const LoadLanguageEvent();
}

class ChangeLanguageEvent extends LanguageEvent {
  final AppLanguage language;

  const ChangeLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

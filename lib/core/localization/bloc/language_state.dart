import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/app_translations.dart';

class LanguageState extends Equatable {
  final AppLanguage language;

  const LanguageState({this.language = AppLanguage.id});

  AppTranslations get tr => AppTranslations.of(language);

  @override
  List<Object?> get props => [language];
}

import 'package:flutter/material.dart';

enum AppLanguage {
  id('id', 'Bahasa Indonesia', 'ID', '🇮🇩', Locale('id', 'ID')),
  en('en', 'English', 'EN', '🇬🇧', Locale('en', 'US')),
  zh('zh', '简体中文', 'ZH', '🇨🇳', Locale('zh', 'CN'));

  final String code;
  final String name;
  final String shortLabel;
  final String flagEmoji;
  final Locale locale;

  const AppLanguage(
    this.code,
    this.name,
    this.shortLabel,
    this.flagEmoji,
    this.locale,
  );

  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.id;
    for (final lang in AppLanguage.values) {
      if (lang.code.toLowerCase() == code.toLowerCase()) {
        return lang;
      }
    }
    return AppLanguage.id;
  }
}

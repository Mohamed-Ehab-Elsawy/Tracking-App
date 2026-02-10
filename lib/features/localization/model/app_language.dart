import 'package:flutter/material.dart';

enum AppLanguage {
  english(Locale('en')),
  arabic(Locale('ar'));

  final Locale locale;

  const AppLanguage(this.locale);

  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return "English";
      case AppLanguage.arabic:
        return "Arabic";
    }
  }
}

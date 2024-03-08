import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String>? _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }

  String translateWithDirection(String key, TextDirection textDirection) {
    if (_localizedStrings == null) return key;

    String translatedText = _localizedStrings![key] ?? key;
    return (textDirection == TextDirection.rtl)
        ? '\u200E$translatedText' // Add Left-to-Right mark for RTL languages
        : translatedText;
  }

  TextDirection getTextDirection() {
    // Set text direction based on the selected language
    switch (locale.languageCode) {
      case 'ar':
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en', 'es', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    String jsonString =
    await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    localizations._localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

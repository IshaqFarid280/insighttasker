import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleConstants {
  static const String prefSelectedLanguageCode = "SelectedLanguageCode";

  static Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(prefSelectedLanguageCode, languageCode);
    print('Language code saved: $languageCode');
    return _locale(languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
    print('Retrieved language code: $languageCode');
    return _locale(languageCode);
  }

  static Locale _locale(String languageCode) {
    print('print the language code in _locale of locale constants: $languageCode');
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('en', '');

  }

  static void changeLanguage(BuildContext context, String selectedLanguageCode) async {

    print('print the change language code in changelanguage: $selectedLanguageCode');
    var _locale = await setLocale(selectedLanguageCode);

    print('Language changed to: $_locale');
    // Update the UI with the new locale if necessary.
    // MyApp.setLocale(context, _locale);
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  late SharedPreferences _preferences;
  late Locale _locale;
  Map<String, String>? _localizedStrings;

  LanguageProvider() {
    _initPreferences();
  }

  Locale get locale => _locale;
  set locale(Locale value) {
    if (_locale != value) {
      _locale = value;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('language_code', value.languageCode);
      }).then((value) {
        _loadTranslations();
      }).then((value) {
        notifyListeners();
      });
    }
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    String? savedLocale = _preferences.getString('language_code');
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
    _loadTranslations();
    notifyListeners();
  }

  // Define a callback function
  VoidCallback? _onLanguageChangeCallback;

  // Set the callback function
  void setLanguageChangeCallback(VoidCallback callback) {
    _onLanguageChangeCallback = callback;
  }

  void changeLanguage(String newLanguage) {
    print('print the changelnaguge from language provider: $newLanguage');
    locale = Locale(newLanguage);
    notifyListeners(); // Notify listeners of the change

    // Call the callback function when the language changes
    _onLanguageChangeCallback?.call();
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }

  Future<void> _loadTranslations() async {
    String jsonString =
        await rootBundle.loadString('assets/i18n/${_locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    print(
        "rebuild in ===> ${_locale.languageCode}; _localizedStrings=$_localizedStrings");
  }
}

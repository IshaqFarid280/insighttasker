import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  // Define a callback function
  VoidCallback? _onLanguageChangeCallback;

  // Set the callback function
  void setLanguageChangeCallback(VoidCallback callback) {
    _onLanguageChangeCallback = callback;
  }


  void changeLanguage(String newLanguage) {
    print('print the changelnaguge from language provider: $newLanguage');
    _currentLanguage = newLanguage;
    notifyListeners(); // Notify listeners of the change


    // Call the callback function when the language changes
    _onLanguageChangeCallback?.call();
  }
}

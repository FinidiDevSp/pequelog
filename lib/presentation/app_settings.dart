import 'package:flutter/material.dart';

/// Holds global presentation settings such as the active locale.
class AppSettings extends ChangeNotifier {
  AppSettings({Locale? initialLocale})
    : _locale = initialLocale ?? const Locale('es');

  Locale _locale;

  /// Current locale for the application.
  Locale get locale => _locale;

  /// Updates the locale and notifies listeners when it changes.
  void setLocale(Locale locale) {
    if (locale == _locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
  }
}

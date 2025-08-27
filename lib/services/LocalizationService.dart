import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

class LocalizationService {
  static const String _languageCodeKey = 'languageCode';

  static Future<Locale> setLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
    return _locale(languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(_languageCodeKey) ?? 'en';
    return _locale(languageCode);
  }

  static Locale _locale(String languageCode) {
    return languageCode.isNotEmpty ? Locale(languageCode) : const Locale('en');
  }

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
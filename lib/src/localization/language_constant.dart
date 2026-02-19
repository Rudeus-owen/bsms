import 'package:bsms/src/core/constants/app_constants.dart';
import 'package:bsms/src/services/secure_storage.dart';
import 'package:flutter/material.dart';

//languages code
const String ENGLISH = 'en';
const String BURMESE = 'my';

Future<Locale> setLocale(String languageCode) async {
  final storage = SecureStorage();
  await storage.writeString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final storage = SecureStorage();
  String languageCode = await storage.readString(LANGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case BURMESE:
      return Locale(BURMESE, "BU");
    default:
      return Locale(ENGLISH, 'US');
  }
}

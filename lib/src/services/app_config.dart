import 'package:flutter/material.dart';

class AppConfig {
  String appVersion = "1.0.0";
  String appName = "Beauty Salon";
  String appDesc = "Management System";
  String baseURL = "";
  MaterialColor primaryColor = Colors.blue;
  bool isInternetMode = true;

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({
    String appName = "Beauty Salon",
    String appDesc = "Management System",
    String appVersion = "1.0.0",
    String baseURL = "",
    MaterialColor primaryColor = Colors.blue,
    bool isInternetMode = true,
  }) {
    return shared = AppConfig(
      appName,
      appDesc,
      appVersion,
      baseURL,
      primaryColor,
      isInternetMode,
    );
  }

  AppConfig(
    this.appName,
    this.appDesc,
    this.appVersion,
    this.baseURL,
    this.primaryColor,
    this.isInternetMode,
  );
}

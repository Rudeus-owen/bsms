import 'dart:convert';
import 'package:flutter/services.dart';

class ApiConfig {
  static String baseUrl = "";

  static Future<void> load() async {
    final String response = await rootBundle.loadString('config/dev.json');
    final data = await json.decode(response);
    baseUrl = data['base_url'];
  }
}

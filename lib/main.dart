import 'package:flutter/material.dart';
import 'myapp.dart';
import 'src/api/api_config.dart';
import 'src/api/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.load();
  ApiService.init();
  runApp(const MyApp());
}

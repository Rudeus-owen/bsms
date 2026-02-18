import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  factory SecureStorage() => _instance;

  SecureStorage._internal();
  static final SecureStorage _instance = SecureStorage._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<void> init() async {

    // final url = await storage.readString(USE_URL) ?? "";
    // final domain = await storage.readString(USE_DOMAIN) ?? "";

    // final isLogin = await storage.readBool(KEY_IS_LOGIN);
    // final isLoginPref = await pref.getBool(KEY_IS_LOGIN) ?? false;

    // if(isLogin == true){
    //    await storage.delete(KEY_IS_LOGIN);
    // }

    // final _updateUrl = await storage.readBool(_version);
    // if (url.isEmpty || domain.isEmpty || !_updateUrl) {
    //   await Future.wait([
    //     storage.writeString(USE_URL, FlavorsConfig.config.baseUrl),
    //     storage.writeString(USE_DOMAIN, FlavorsConfig.config.domain),
    //     storage.writeBool(_version, true),
    //     //pref.setBool(KEY_IS_LOGIN, isLogin),
    //     storage.writeString(USER_DATA, userData)
    //   ]);
    // }
  }

  Future<void> writeString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readString(String key) async {
    return _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  Future<void> writeBool(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<bool> readBool(String key) async {
    final String? value = await _secureStorage.read(key: key);
    return value == 'true';
  }

  Future<void> writeInt(String key, int value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<int> readInt(String key) async {
    final String value = await _secureStorage.read(key: key) ?? '0';
    return int.parse(value);
  }

  Future<void> writeStringList(String key, List<String> list) async {
    final jsonString = jsonEncode(list);
    await _secureStorage.write(key: key, value: jsonString);
  }

  Future<List<String>> readStringList(String key) async {
    final jsonString = await _secureStorage.read(key: key);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<String>();
  }
}

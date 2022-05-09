import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final storage = FlutterSecureStorage();

  static isLoggedIn() async {
    await storage.containsKey(key: "userData");
  }

  static Future<String?> getToken() async {
    final keyExists = await storage.containsKey(key: "userData");
    if (keyExists) {
      final value = await storage.read(key: "userData");
      return value;
    }
    return null;
  }

  static Future<void> setToken(String data) async {
    await storage.write(key: "userData", value: data);
  }

  static Future<void> removeToken() async {
    await storage.delete(key: "userData");
  }
}

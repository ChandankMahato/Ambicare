import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../secrets/secrets.dart';
import '../services/storage.dart';

class Authentication {
  static Future<int?> signUp(Map<String, dynamic> body) async {
    try {
      final response = await Dio().post(API.endPoint + API.signUp, data: body);
      final resData = response.data;
      await Storage.setToken(json.encode(resData));
      return response.statusCode!;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      await Dio().post(API.endPoint + API.signUp, data: body);
      return -1;
    }
  }

  static Future<int?> signIn(Map<String, dynamic> body) async {
    try {
      final response = await Dio().post(API.endPoint + API.signIn, data: body);
      await Storage.setToken(json.encode(response.data));
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<bool> signOut() async {
    try {
      await Storage.removeToken();
      return true;
    } on PlatformException catch (ex) {
      return false;
    }
  }
}

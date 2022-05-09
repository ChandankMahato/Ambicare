import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../secrets/secrets.dart';
import '../services/storage.dart';

class Authentication {
  static Future<int?> signIn(Map<String, dynamic> body) async {
    try {
      final response = await Dio().post(
        API.endPoint + API.signIn,
        data: body,
      );
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
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      await Dio().post(
        API.endPoint + API.signOut,
        data: {
          "registrationNumber": tokenData["regNo"],
        },
        options: Options(
          headers: {
            "x-auth-token": tokenData["token"],
          },
        ),
      );
      await Storage.removeToken();
      return true;
    } on DioError catch (ex) {
      return false;
    } on PlatformException catch (ex) {
      return false;
    }
  }
}

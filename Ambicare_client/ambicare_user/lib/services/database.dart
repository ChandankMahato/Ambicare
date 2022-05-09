import 'dart:convert';

import 'package:ambicare_user/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../secrets/secrets.dart';

class Database {
  static Future<List> getAllAmbulances() async {
    try {
      String? token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().get(
        API.endPoint + API.allAmbulances,
        options: Options(
          headers: {
            "x-auth-token": tokenData["token"],
          },
        ),
      );
      return response.data;
    } on DioError catch (ex) {
      return [];
    } on PlatformException catch (ex) {
      return [];
    }
  }

  static Future<int?> sendRequest(Map<String, dynamic> data) async {
    print(data);
    try {
      String? token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().post(
        API.endPoint + API.sendRequest,
        options: Options(
          headers: {"x-auth-token": tokenData["token"]},
        ),
        data: data,
      );
      print(response);
      return response.statusCode;
    } on DioError catch (ex) {
      print(ex.response);
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<List> getUserHistory() async {
    String? token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response = await Dio().get(API.endPoint + API.userHistory,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }));
    return response.data;
  }

  static Future<Map<String, dynamic>> getProfile() async {
    String? token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response = await Dio().get(API.endPoint + API.profile,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }));
    return response.data;
  }

  static Future<Map<String, dynamic>> getRequest() async {
    final token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response = await Dio().get(API.endPoint + API.userRequest,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }));
    return response.data;
  }

  static Future<Map<String, dynamic>> getDriversToken(String driverId) async {
    try {
      String? token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().get(
        API.endPoint + API.getToken + driverId,
        options: Options(
          headers: {"x-auth-token": tokenData["token"]},
        ),
      );
      return response.data;
    } on DioError catch (ex) {
      return {};
    } on PlatformException catch (ex) {
      return {};
    }
  }

  static Future<int?> changePassword(Map<String, dynamic> data) async {
    try {
      final response =
          await Dio().put(API.endPoint + API.changePassword, data: data);
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    }
  }

  static Future<int?> userExists(String phoneNumber) async {
    try {
      final response = await Dio().get(
        API.endPoint + API.userExists + phoneNumber,
      );
      return response.statusCode!;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }
}

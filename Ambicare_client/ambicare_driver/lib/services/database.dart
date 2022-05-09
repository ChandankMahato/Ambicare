import 'dart:convert';

import 'package:ambicare_driver/secrets/secrets.dart';
import 'package:ambicare_driver/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class Database {
  static Future<Map<String, dynamic>> getNewRequest() async {
    final token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response =
        await Dio().get(API.endPoint + API.newRequest + tokenData["id"],
            options: Options(headers: {
              "x-auth-token": tokenData["token"],
            }));
    return response.data;
  }

  static Future<int?> completeRequest(
      String requestId, Map<String, dynamic> data) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().put(
        API.endPoint + API.requestComplete + requestId,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
        data: data,
      );
      return response.statusCode;
    } on DioError catch (ex) {
      print(ex.response);
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<int?> updateAmbulancePosition(
      {double? lat, double? lng}) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().put(
        API.endPoint + API.updateAmbulanceLocation,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
        data: {
          "latitude": lat,
          "longitude": lng,
          "regNo": tokenData["regNo"],
        },
      );
      return response.statusCode;
    } on DioError catch (ex) {
      return 400;
    } on PlatformException catch (ex) {
      return -1;
    }
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

  static Future<List> getDriverHistory() async {
    String? token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response = await Dio().get(API.endPoint + API.driverHistory,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }));
    return response.data;
  }

  static Future<Map<String, dynamic>> getAmbulance() async {
    String? token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response =
        await Dio().get(API.endPoint + API.ambulance + tokenData["regNo"],
            options: Options(headers: {
              "x-auth-token": tokenData["token"],
            }));
    return response.data;
  }

  static Future<int?> changeAvailability(
      bool newState, String ambulanceId) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().put(
        API.endPoint + API.changeAvailability,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
        data: {
          "id": ambulanceId,
          "isAvailable": newState,
        },
      );
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<Map<String, dynamic>> getToken() async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().get(
        API.endPoint + API.getToken + tokenData["id"],
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
      );
      return response.data ?? {};
    } on DioError catch (ex) {
      return {};
    } on PlatformException catch (ex) {
      return {};
    }
  }

  static Future<int?> saveToken(String messagingToken) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().put(
        API.endPoint + API.saveToken,
        options: Options(
          headers: {
            "x-auth-token": tokenData["token"],
          },
        ),
        data: {
          "token": messagingToken,
        },
      );
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
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

  static Future<int?> driverExists(String phoneNumber) async {
    try {
      final response = await Dio().get(
        API.endPoint + API.driverExists + phoneNumber,
      );
      return response.statusCode!;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }
}

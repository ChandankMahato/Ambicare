import 'dart:convert';
import 'package:ambicare_service/models/ambulance.dart';
import 'package:ambicare_service/secrets/secrets.dart';
import 'package:ambicare_service/services/storage.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class Database {
  static Future<List> getAllAmbulances() async {
    final token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response =
        await Dio().get(API.endPoint + API.allAmbulances + tokenData["id"],
            options: Options(headers: {
              "x-auth-token": tokenData["token"],
            }));
    return response.data;
  }

  static Future<Map<String, dynamic>> profile() async {
    final token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response = await Dio().get(API.endPoint + API.profile,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }));
    return response.data;
  }

  static Future<int?> saveAmbulance(Map<String, dynamic> data) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().post(
        API.endPoint + API.addAmbulance,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
        data: data,
      );
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
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

  static Future<List> getAllDrivers() async {
    final token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response =
        await Dio().get(API.endPoint + API.allDrivers + tokenData["id"],
            options: Options(headers: {
              "x-auth-token": tokenData["token"],
            }));
    return response.data;
  }

  static Future<int?> saveDriver(Map<String, dynamic> data) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      print(tokenData);
      final response = await Dio().post(
        API.endPoint + API.addDriver,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
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

  static Future<int?> deleteDriver(String id) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().delete(
        API.endPoint + API.deleteDriver + id,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
      );
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<int?> deleteAmbulance(String id) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().delete(
        API.endPoint + API.deleteAmbulance + id,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
      );
      return response.statusCode;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<int?> updateAmbulanceType(
      String newType, String ambulanceId) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().put(
        API.endPoint + API.updateType,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
        data: {
          "id": ambulanceId,
          "type": newType,
        },
      );
      print(response.data);
      return response.statusCode;
    } on DioError catch (ex) {
      print(ex.response!.data);
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<Map<String, dynamic>> driverDetails(String id) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response = await Dio().put(
        API.endPoint + API.changeAvailability,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }),
      );
      return response.data;
    } on DioError catch (ex) {
      return {};
    } on PlatformException catch (ex) {
      return {};
    }
  }

  static Future<List> getServiceHistory() async {
    String? token = await Storage.getToken();
    Map<String, dynamic> tokenData = json.decode(token!);
    final response = await Dio().get(API.endPoint + API.serviceHistory,
        options: Options(headers: {
          "x-auth-token": tokenData["token"],
        }));
    return response.data;
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

  static Future<int?> serviceExists(String phoneNumber) async {
    try {
      final response = await Dio().get(
        API.endPoint + API.serviceExists + phoneNumber,
      );
      return response.statusCode!;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }

  static Future<int?> driverExists(String phoneNumber) async {
    try {
      final token = await Storage.getToken();
      Map<String, dynamic> tokenData = json.decode(token!);
      final response =
          await Dio().get(API.endPoint + API.driverExists + phoneNumber,
              options: Options(headers: {
                "x-auth-token": tokenData["token"],
              }));
      return response.statusCode!;
    } on DioError catch (ex) {
      return ex.response!.statusCode;
    } on PlatformException catch (ex) {
      return -1;
    }
  }
}

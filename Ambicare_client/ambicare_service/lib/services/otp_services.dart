import '../secrets/secrets.dart';
import 'package:dio/dio.dart';

class OtpServices {
  static final Dio _dio = Dio();
  static Future<Map<String, dynamic>> sendOtp(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(API.endPoint + API.sendOtp, data: body);
      return response.data as Map<String, dynamic>;
    } on DioError catch (ex) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      Map<String, dynamic> body) async {
    try {
      final response =
          await _dio.post(API.endPoint + API.verifyOtp, data: body);
      return response.data as Map<String, dynamic>;
    } on DioError catch (ex) {
      return {};
    }
  }
}

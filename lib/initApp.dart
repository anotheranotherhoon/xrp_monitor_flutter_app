import 'dart:io';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/services/base/models/api_response.dart';
import 'package:xrp_monitor/core/services/base/models/response_exception.dart';
import 'package:xrp_monitor/core/services/base/models/version_model.dart';
import 'core/services/base/models/response_model.dart';
import 'package:dio/dio.dart' as dio;

class InitApp {
  static const String androidVersion = '1.0.1';
  static const String iosVersion = '1.0.1';

  static Future<ResponseModel<Version>> checkVersion() async {
    return _fetchVersion();
  }

  static Future<ResponseModel<Version>> _fetchVersion() async {
    try {
      final response = await dio.Dio(
        dio.BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ).get<Map<String, dynamic>>(
        '${ApiPath.apiUrl}version/check',
        queryParameters: {
          'currentVersion': Platform.isIOS ? iosVersion : androidVersion,
          'platform': Platform.isIOS ? 'ios' : 'aos',
        },
        options: dio.Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        if (apiResponse.success) {
          Version? result;
          int status = 1;

          if (apiResponse.result?.data != null &&
              apiResponse.result?.data is Map<String, dynamic>) {
            result = Version.fromJson(
              apiResponse.result?.data as Map<String, dynamic>,
            );
          }

          return ResponseModel(
            success: true,
            type: ResponseType.success,
            result: result,
            code: status,
          );
        } else {
          return throw ResponseException(
            ResponseModel(success: false, type: ResponseType.alert),
          );
        }
      } else {
        return throw ResponseException(
          ResponseModel(success: false, type: ResponseType.alert),
        );
      }
    } catch (err) {
      return throw Exception(err);
    }
  }
}

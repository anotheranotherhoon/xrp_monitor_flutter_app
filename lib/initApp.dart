import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_exception.dart';
import 'package:xrp_monitor/core/models/common/version_model.dart';
import 'core/models/common/response_model.dart';
import 'package:dio/dio.dart' as dio;



class InitApp {
  static const String androidVersion = '1.0.1';
  static const String iosVersion = '1.0.1';

  static Future<ResponseModel<VersionModel>> checkVersion() async {
    final ResponseModel<VersionModel> response = await _fetchVersion();
    if(response.success && response.result != null ){
      switch (response.result!.apiDomain) {
        case ApiPath.devDomain:
          ApiPath.setServerType(ServerType.dev);
          break;
        case ApiPath.betaDomain:
          ApiPath.setServerType(ServerType.beta);
          break;
        case ApiPath.prodDomain:
          ApiPath.setServerType(ServerType.prod);
          break;
      }
    }
    return response;
  }


  static Future<ResponseModel<VersionModel>> _fetchVersion() async {
    try {
      final response = await dio.Dio().get<Map<String, dynamic>>(
        '${ApiPath.apiUrl}version/check',
        queryParameters: {
          'currentVersion': Platform.isIOS ? iosVersion : androidVersion,
          'platform': Platform.isIOS ? 'ios' : 'aos',
        },
        options: dio.Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        if (apiResponse.success) {
          VersionModel? result;
          int status = 1;

          print('${apiResponse.result?.data} apiResponse.result?.data');
          if (apiResponse.result?.data != null && apiResponse.result?.data is Map<String, dynamic>) {
            result = VersionModel.fromJson(apiResponse.result?.data as Map<String, dynamic>);
          }

          return ResponseModel(
            success: true,
            type: ResponseType.success,
            result: result,
            code: status,
          );
        } else {
          return throw ResponseException(
            ResponseModel(
              success: false,
              type: ResponseType.alert,
            ),
          );
        }
      } else {
        return throw ResponseException(
          ResponseModel(
            success: false,
            type: ResponseType.alert,
          ),
        );
      }
    } catch (err) {
      return throw Exception(err);
    }
  }

}
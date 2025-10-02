import 'dart:developer';

import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_constants.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_service.g.dart';

@riverpod
class SessionService extends _$SessionService {
  late final ApiService _apiService;

  @override
  void build() {
    _apiService = ref.read(apiServiceProvider.notifier);
  }
  Future<ResponseModel> getMyInfo() async {
    try {
      final response = await _apiService.get(url: '${ApiConstants.apiDomain}v1/member/profile');
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        return ResponseModel(success: true, type: ResponseType.success, result: apiResponse.result);
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "",
          content: "",
        );
      }
    } catch (err) {
      log(err.toString());
      return throw Exception(err);
    }
  }
  Future<ResponseModel> getEnvInfo() async {
    try {
      final response = await _apiService.get(url: '${ApiConstants.apiDomain}v1/content/env-value');
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        return ResponseModel(success: true, type: ResponseType.success, result: apiResponse.result);
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "",
          content: "",
        );
      }
    } catch (err) {
      log(err.toString());
      return throw Exception(err);
    }
  }
  Future<ResponseModel> getMyToken() async {
    try {
      final response = await _apiService.get(url: '${ApiConstants.apiDomain}v1/member/device-token');
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        return ResponseModel(success: true, type: ResponseType.success, result: apiResponse.result);
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "",
          content: "",
        );
      }
    } catch (err) {
      log(err.toString());
      return throw Exception(err);
    }
  }
}

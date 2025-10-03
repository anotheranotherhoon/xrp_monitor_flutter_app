import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_constants.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/service/authentication/models/auth_model.dart';
import 'package:xrp_monitor/service/authentication/models/signup_request.dart';
import 'package:xrp_monitor/service/authentication/models/login_request.dart';

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
      final response = await _apiService.get(url: '${ApiPath.apiUrl}v1/member/profile');
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
      final response = await _apiService.get(url: '${ApiPath.apiUrl}v1/member/device-token');
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

  Future<ResponseModel> signUp(SignUpRequest request) async {
    try {
      final response = await _apiService.post(
        url: '${ApiPath.apiUrl}auth/register',
        params: request.toJson(),
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        return ResponseModel(
          success: true,
          type: ResponseType.success,
          result: apiResponse.result,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "회원가입 실패",
          content: "회원가입에 실패했습니다.",
        );
      }
    } catch (err) {
      log(err.toString());
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
      );
    }
  }

  Future<ResponseModel<LoginResult>> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        url: '${ApiPath.apiUrl}auth/login',
        params: request.toJson(),
      );
      if (response.statusCode == 200) {
        print(response.data!);
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        print('apiResponse.result ${apiResponse.result?.data}');
        final LoginResult loginUser = LoginResult.fromJson(apiResponse.result?.data);
        print(loginUser);
        return ResponseModel(
          success: true,
          type: ResponseType.success,
          result: loginUser,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "로그인 실패",
          content: "이메일 또는 비밀번호가 잘못되었습니다.",
        );
      }
    } catch (err) {
      log(err.toString());
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
      );
    }
  }
}

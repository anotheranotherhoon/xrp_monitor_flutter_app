import 'package:dio/dio.dart' as dio;
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_constants.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:xrp_monitor/service/authentication/models/auth_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  ApiService get _apiService => ref.read(apiServiceProvider.notifier);

  @override
  Future<void> build() async {
    // _apiService = ApiService();
  }

  Future<ResponseModel> login(String id, String password) async {
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/member/login',
          params:{
            'email': id,
            'password': password,
          });
      return returnLoginResponseData(response);
    } on dio.DioException catch (dioError) {
      return returnLoginResponseData(dioError.response);
    }  catch (e) {
      print("Login error: $e");
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: '로그인 실패',
        content: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }

  }

  ResponseModel returnLoginResponseData(response) {
    var code = response.data?["code"] ?? 404;
    switch (response.statusCode) {
      case 200:
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        return ResponseModel(success: true, type: ResponseType.success, result: apiResponse.result);
      default:
        if (code == -101) {
          return ResponseModel(
              success: false, type: ResponseType.alert, title: '', content: "", result: {'type':'wrongId'});
        }
        if (code == -611 || code == -604) {
          return ResponseModel(
              success: false, type: ResponseType.alert, title: '', content: "", result: {'type':'wrongPassword'});
        }
        return ResponseModel(
            success: false, type: ResponseType.alert, title: '로그인 실패', content: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.', result: {'type':'error'});
    }
  }


  Future<ResponseModel> kakaoLogin(params) async {
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/member/oauth2/kakao',
          params:params);
      return returnLoginResponseData(response);
    } on dio.DioException catch (dioError) {
      return returnLoginResponseData(dioError.response);
    }  catch (e) {
      print("Login error: $e");
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: '로그인 실패',
        content: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }
  Future<ResponseModel> googleLogin(params) async {
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/member/oauth2/google',
          params:params);
      return returnLoginResponseData(response);
    } on dio.DioException catch (dioError) {
      return returnLoginResponseData(dioError.response);
    }  catch (e) {
      print("Login error: $e");
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: '로그인 실패',
        content: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }
  Future<ResponseModel> appleLogin(params) async {
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/member/oauth2/apple',
          params:params);
      return returnLoginResponseData(response);
    } on dio.DioException catch (dioError) {
      return returnLoginResponseData(dioError.response);
    }  catch (e) {
      print("Login error: $e");
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: '로그인 실패',
        content: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }

  Future<ResponseModel<bool>> checkEmailDuplicate(String email) async{
    try {
      final response = await _apiService.get(
        url: '${ApiConstants.apiUrl}v1/member/check/email/$email',
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final Map<String, dynamic> resultData = apiResponse.result?.data as Map<String, dynamic>;
        final bool result = resultData['availability'] == 'DENIED';
        return ResponseModel<bool>(
          success: true,
          type: ResponseType.success,
          result: result,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          type: ResponseType.etc,
        );
      }
    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }


  Future<ResponseModel<bool>> sendCertCode(SendCertParams params) async{
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/auth/email/send-cert',
          params: params.toJson()
      );

      if (response.statusCode == 200) {
        return ResponseModel<bool>(
          success: true,
          type: ResponseType.success,
          result: true,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          type: ResponseType.etc,
        );
      }
    } catch (err) {

      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }

  Future<ResponseModel<bool>> verifyCertCode(VerifyCertParams params) async{
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/auth/email/verify-cert',
          params: params.toJson()
      );

      if (response.statusCode == 200) {
        return ResponseModel<bool>(
          success: true,
          type: ResponseType.success,
          result: true,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          type: ResponseType.etc,
        );
      }
    } on dio.DioException catch (dioError) {
      final apiResponse = ApiResponse.fromJson(dioError.response?.data as Map<String, dynamic>);
      return ResponseModel(
        success: false,
        code: apiResponse.code,
        type: ResponseType.etc,
        result: false,
      );

    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }

  Future<ResponseModel<bool>> checkNickNameDuplicate(String nickName) async{
    try {
      final response = await _apiService.get(
        url: '${ApiConstants.apiUrl}v1/member/check/nickname/$nickName',
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final Map<String, dynamic> resultData = apiResponse.result?.data as Map<String, dynamic>;
        final bool result = resultData['availability'] == 'DENIED';
        return ResponseModel<bool>(
          success: true,
          type: ResponseType.success,
          result: result,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          type: ResponseType.etc,
        );
      }
    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }

  Future<ResponseModel<bool>> checkRecommendCode(String recommendCode) async{
    try {
      final response = await _apiService.get(
        url: '${ApiConstants.apiUrl}v1/member/check/recommend-code/$recommendCode',
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final Map<String, dynamic> resultData = apiResponse.result?.data as Map<String, dynamic>;
        final bool result = resultData['recommendCodeExists'] == 'EXISTS';
        return ResponseModel<bool>(
          success: true,
          type: ResponseType.success,
          result: result,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          type: ResponseType.etc,
          result: false,
        );
      }
    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }

  Future<ResponseModel<SignUpResult>> signUp(Map<String, dynamic> params) async{
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/member/register',
          params: params
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final Map<String, dynamic> resultData = apiResponse.result?.data as Map<String, dynamic>;
        final SignUpResult result = SignUpResult.fromJson(resultData);
        return ResponseModel<SignUpResult>(
          success: true,
          type: ResponseType.success,
          result: result,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.etc,
        );
      }
    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }

  Future<ResponseModel<bool>> checkIsRecommendCodeApplicable(Map<String, dynamic> params) async{
    try {
      final response = await _apiService.get(
          url: '${ApiConstants.apiUrl}v1/member/recommend-code/applicable',
          params: params
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final Map<String, dynamic> resultData = apiResponse.result?.data as Map<String, dynamic>;
        final bool result = resultData['applicable'];
        return ResponseModel<bool>(
          success: true,
          type: ResponseType.success,
          result: result,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.etc,
        );
      }
    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }


  Future<ResponseModel<SignUpResult>> completeSocial(Map<String, dynamic> params) async{
    try {
      final response = await _apiService.post(
          url: '${ApiConstants.apiUrl}v1/member/oauth2/complete',
          params: params
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final Map<String, dynamic> resultData = apiResponse.result?.data as Map<String, dynamic>;
        final SignUpResult result = SignUpResult.fromJson(resultData);
        return ResponseModel<SignUpResult>(
          success: true,
          type: ResponseType.success,
          result: result,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.etc,
        );
      }
    } catch (err) {
      return ResponseModel(
        success: false,
        type: ResponseType.etc,
      );
    }
  }
}


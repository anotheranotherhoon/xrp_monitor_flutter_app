import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/services/base/api_constants.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  bool isCheckDeviceToken = false;
  final ApiService _apiService;

  TokenService(this._apiService);

  Future<String?> _getToken() async {
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
    String? fcmKey = '';
    if (!kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        fcmKey = await FirebaseMessaging.instance.getToken();
        await prefs.setString('deviceToken', fcmKey.toString());
      } catch (e) {
        if (kDebugMode) {
          print('Error retrieving FCM Token: $e');
        }
      }
    }
    return fcmKey;
  }

  writeToken(String deviceType) async {
    if (kIsWeb) {
      return -1;
    }
    final prefs = await SharedPreferences.getInstance();
    String? deviceToken = prefs.getString('deviceToken');
    if (deviceToken != null) {
      updateDeviceToken(deviceToken, deviceType);
    } else {
      String? device = await _getToken();
      if (device != null) {
        updateDeviceToken(device, deviceType);
      }
    }
  }

  Future<dynamic> updateDeviceToken(String device, String deviceType) async {
    if (await _isAlreadySetToken(device)) {
      return;
    }
    String url = '${ApiConstants.apiDomain}v1/member/device-token';
    final response = await _apiService.post(url: url, params: {"deviceToken": device, "osType": deviceType});
    if (response.statusCode == 200 && response.data != null) {
      final apiResponse = ApiResponse.fromJson(response.data!);
      if (apiResponse.success && apiResponse.code == 1) {
        return apiResponse.result?.data;
      }
    }
    return -1;
  }

  Future<dynamic> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceToken = prefs.getString('deviceToken');
    String url = '${ApiConstants.apiDomain}v1/member/device-token/$deviceToken';
    try {
      final response = await _apiService.delete(url: url, params: {});
      if (response.statusCode == 200 && response.data != null) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        if (apiResponse.success && apiResponse.code == 1) {
          await FirebaseMessaging.instance.deleteToken();
          prefs.remove('deviceToken');
          return apiResponse.result?.data['code'];
        }
      }
      return -1;
    } catch (e) {
      return -1;
    }
  }

  Future<dynamic> checkDeviceToken(String deviceToken, String deviceType) async {
    if (isCheckDeviceToken) {
      updateDeviceToken(deviceToken, deviceType);
    } else {
      String url = '${ApiConstants.apiDomain}v1/member/device-token';
      String nowToken = 'none';
      final response = await _apiService.get(url: url, params: {});
      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = ApiResponse.fromJson(response.data!);
        if (apiResponse.success && apiResponse.code == 1) {
          nowToken = apiResponse.result?.data[0]['deviceToken'];
        }
      }
      if (nowToken == deviceToken) {
        updateDeviceToken(deviceToken, deviceType);
        return -1;
      } else {
        await FirebaseMessaging.instance.deleteToken();
        String? device = await _getToken();
        if (device != null) {
          updateDeviceToken(device, deviceType);
        }
      }
      isCheckDeviceToken = true;
      return -1;
    }
  }

  Future<bool> _isAlreadySetToken(String deviceToken) async {
    String url = '${ApiConstants.apiDomain}v1/member/device-token';
    final response = await _apiService.get(url: url, params: {});
    if (response.statusCode == 200 && response.data != null) {
      final apiResponse = ApiResponse.fromJson(response.data!);
      if (apiResponse.success && apiResponse.code == 1) {
        final List deviceList = apiResponse.result?.data;
        final int index = deviceList.indexWhere((data) {
          return data['deviceToken'] == deviceToken;
        });
        //nowToken = apiResponse.result?.data[0]['deviceToken'];
        return index > -1;
      }
    }
    return false;
  }
}

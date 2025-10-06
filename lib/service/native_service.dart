import 'package:flutter/services.dart';

class NativeService {
  static const MethodChannel _channel = MethodChannel('xrp_monitor/native');

  /// 네이티브 푸시 알림 표시
  static Future<void> showNativeNotification({
    required String title,
    required String message,
    bool withVibration = true,
  }) async {
    try {
      await _channel.invokeMethod('showNotification', {
        'title': title,
        'message': message,
        'withVibration': withVibration,
      });
    } catch (e) {
      print('Error showing native notification: $e');
    }
  }

  /// 네이티브 진동 실행
  static Future<void> vibrate({int duration = 500}) async {
    try {
      await _channel.invokeMethod('vibrate', {
        'duration': duration,
      });
    } catch (e) {
      print('Error vibrating: $e');
    }
  }


  /// 앱 업데이트 알림 (appStatus != 1일 때)
  static Future<void> showUpdateNotification({
    required int appStatus,
    String? downloadUrl,
    List<String>? releaseNotes,
  }) async {
    String title = '';
    String message = '';

    switch (appStatus) {
      case 0:
        title = '앱 업데이트 필요';
        message = '새로운 버전이 출시되었습니다. 업데이트 후 이용해주세요.';
        break;
      case 2:
        title = '필수 업데이트';
        message = '필수 업데이트가 필요합니다. 지금 업데이트해주세요.';
        break;
      case 3:
        title = '서비스 점검 중';
        message = '현재 서비스 점검 중입니다. 잠시 후 다시 이용해주세요.';
        break;
      default:
        title = '앱 상태 알림';
        message = '앱 상태를 확인해주세요.';
    }

    await showNativeNotification(
      title: title,
      message: message,
      withVibration: true,
    );
  }
}
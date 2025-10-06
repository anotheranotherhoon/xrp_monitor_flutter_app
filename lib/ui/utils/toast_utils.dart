import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  /// 키보드 높이를 고려한 토스트 위치 결정
  static ToastGravity _getToastGravity(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // 키보드가 올라와 있으면 (높이 100 이상) CENTER로, 아니면 BOTTOM으로
    return bottomInset > 100 ? ToastGravity.CENTER : ToastGravity.BOTTOM;
  }

  /// 키보드 상태를 고려한 안전한 토스트 표시
  static void showSafeToast(
    BuildContext context, 
    String message, {
    bool isSuccess = false,
    Toast toastLength = Toast.LENGTH_SHORT,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: _getToastGravity(context),
      backgroundColor: isSuccess 
          ? Colors.green.shade700 
          : Colors.red.shade700,
      textColor: Colors.white,
      fontSize: fontSize,
    );
  }

  /// 성공 토스트 표시
  static void showSuccess(BuildContext context, String message) {
    showSafeToast(context, message, isSuccess: true);
  }

  /// 성공 토스트 표시 후 콜백 실행 (화면 전환용)
  static void showSuccessWithCallback(
    BuildContext context, 
    String message, 
    VoidCallback onComplete, {
    int delayMs = 800, // 토스트 표시 시간
  }) {
    showSafeToast(context, message, isSuccess: true, toastLength: Toast.LENGTH_SHORT);
    
    // 지정된 시간 후 콜백 실행 (화면 전환)
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (context.mounted) {
        onComplete();
      }
    });
  }

  /// 에러 토스트 표시
  static void showError(BuildContext context, String message) {
    showSafeToast(context, message, isSuccess: false);
  }

  /// 정보 토스트 표시 (중성 색상)
  static void showInfo(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: _getToastGravity(context),
      backgroundColor: Colors.grey.shade700,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
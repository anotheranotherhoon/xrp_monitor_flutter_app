import 'package:xrp_monitor/constants/validation.constants.dart';

class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegExp = RegExp(ValidationConstants.emailRegExp);
    if (!emailRegExp.hasMatch(value)) {
      return '올바른 이메일 형식을 입력해주세요';
    }
    return null;
  }

  static String? nicknameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.length < ValidationConstants.minNicknameLength) {
      return '닉네임은 ${ValidationConstants.minNicknameLength}자 이상이어야 합니다';
    }
    if (value.length > ValidationConstants.maxNicknameLength) {
      return '닉네임은 ${ValidationConstants.maxNicknameLength}자 이하여야 합니다';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < ValidationConstants.minPasswordLength) {
      return '비밀번호는 ${ValidationConstants.minPasswordLength}자 이상이어야 합니다';
    }
    final passwordRegExp = RegExp(ValidationConstants.passwordRegExp);
    if (!passwordRegExp.hasMatch(value)) {
      return '영문, 숫자, 특수문자를 포함해야 합니다';
    }
    return null;
  }

  static String? simplePasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }
    if (value != password) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  // Custom validators
  static String? quantityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '보유 수량을 입력해주세요';
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return '올바른 수량을 입력해주세요';
    }
    return null;
  }

  static String? averagePriceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '평균 매수가를 입력해주세요';
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return '올바른 가격을 입력해주세요';
    }
    return null;
  }
}
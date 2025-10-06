class Formatter {

  static String formatWithComma(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  static String formatWithCommaAndDecimal(double number, int decimalPlaces) {
    return number.toStringAsFixed(decimalPlaces).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  static String formatWithCommaNoLimit(double number) {
    String numberStr = number.toString();
    List<String> parts = numberStr.split('.');
    
    // 정수 부분에 콤마 추가
    String integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    
    // 소수점 부분이 있으면 그대로 붙이기
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '$integerPart.${parts[1]}';
    } else {
      return integerPart;
    }
  }

}
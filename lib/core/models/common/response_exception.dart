import 'package:xrp_monitor/core/models/common/response_model.dart';

class ResponseException<T extends Object> implements Exception {
  ResponseException(this.response);
  final ResponseModel<T> response;
}

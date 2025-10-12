import 'package:xrp_monitor/core/services/base/models/response_model.dart';

class ResponseException<T extends Object> implements Exception {
  ResponseException(this.response);
  final ResponseModel<T> response;
}

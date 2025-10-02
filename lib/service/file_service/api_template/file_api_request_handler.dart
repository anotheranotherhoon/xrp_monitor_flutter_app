import 'package:dio/dio.dart';
import 'package:xrp_monitor/core/services/base/api_constants.dart';
import 'package:xrp_monitor/service/file_service/dio/dio.dart';
import 'package:xrp_monitor/service/storage/local_storage_service.dart';



Dio FileApiRequestHandler() {
  final dio =  createFileDio(BaseOptions(
    baseUrl: ApiConstants.apiDomain,
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  ));

  final String? token = LocalStorageService.instance.getAccessToken();
  if (token != null) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
  return dio;
}
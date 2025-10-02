import 'package:dio/dio.dart' as dio;
import 'package:xrp_monitor/service/file_service/api/file_delete.dart';
import 'package:xrp_monitor/service/file_service/api/file_get_pre_sign.dart';
import 'package:xrp_monitor/service/file_service/api_template/file_api_request_handler.dart';
import 'package:xrp_monitor/service/file_service/api_template/file_rest_api.dart';
import 'package:xrp_monitor/service/file_service/models/api_get_pre_sign_params.dart';
import 'package:xrp_monitor/service/file_service/models/api_get_pre_sign_response.dart';


class FileApiService {

  Future<ApiGetPreSignResponseBody?> getPreSignUrl(ApiGetPreSignParams params) async {
    final response = await FileGetPreSignRequestV1(params: params).invoke(FileApiRequestHandler());
    if(response == null || response.statusCode != 200 || response.data['code'] != 1) {
      return null;
    }
    final body = ApiGetPreSignResponseBody.fromJson(response.data['result']['data']);
    return body;
  }

  Future<bool> deleteFile(int atIdx) async {
    final response = await FileDeleteV1(atIdx: atIdx).invoke(FileApiRequestHandler());
    if(response == null || response.statusCode != 200 || response.data['code'] != 1) {
      return false;
    }
    return true;
  }

  Future<dio.Response> getFileData(String url, ) async {
    return await dio.Dio().get(url, options: dio.Options(responseType: dio.ResponseType.bytes));
  }
}
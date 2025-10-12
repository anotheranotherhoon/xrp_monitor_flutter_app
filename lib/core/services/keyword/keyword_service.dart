import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:xrp_monitor/core/services/base/models/api_response.dart';
import 'package:xrp_monitor/core/services/base/models/response_exception.dart';
import 'package:xrp_monitor/core/services/base/models/response_model.dart';
import 'package:xrp_monitor/core/services/keyword/models/keyword_model.dart';


part 'keyword_service.g.dart';

@riverpod
class KeywordService extends _$KeywordService {

  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {

  }

  Future<ResponseModel<KeywordListResponse>> getAllKeywords() async {
    try {
      final response = await _apiService.get(
          url: '${ApiPath.apiUrl}keyword'
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        
        KeywordListResponse? keywordData;
        if(apiResponse.result?.data != null){
          keywordData = KeywordListResponse.fromJson(apiResponse.result!.data as Map<String, dynamic>);
        }else{
          keywordData = KeywordListResponse(
            positiveKeywords: [],
            negativeKeywords: [],
            importantKeywords: [],
          );
        }

        return ResponseModel<KeywordListResponse>(
          success: true,
          type: ResponseType.success,
          result: keywordData,
        );
      } else {
        return ResponseModel(success: false, type: ResponseType.alert);
      }
    } catch (err) {
      return throw
      ResponseException(
          ResponseModel(
            success: false,
            type: ResponseType.alert,
            title: '뉴스 정보 조회 실패',
          )
      );
    }
  }






}
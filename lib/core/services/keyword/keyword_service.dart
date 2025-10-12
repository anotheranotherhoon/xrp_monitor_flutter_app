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
        
        // 디버깅: API 응답 로그
        print('KeywordService API 응답: ${response.data}');
        print('apiResponse.result?.data: ${apiResponse.result?.data}');
        
        KeywordListResponse? keywordData;
        if(apiResponse.result?.data != null){
          keywordData = KeywordListResponse.fromJson(apiResponse.result!.data as Map<String, dynamic>);
          print('키워드 데이터 파싱 성공');
        }else{
          print('API 응답에 키워드 데이터가 없어서 빈 배열로 생성');
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
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:xrp_monitor/core/services/twitter/models/twitter_model.dart';

part 'twitter_service.g.dart';

@riverpod
class TwitterService extends _$TwitterService {
  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);
  @override
  void build() {

  }

  Future<ResponseModel<List<Twitter>>> getTweetById(TwitterIdParams params) async {
    try {
      final response = await _apiService.get(
        url: '${ApiPath.apiUrl}tweet/users/${params.id}/tweets',
      );

      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final List<Twitter> data = [];
        for (final Map<String, dynamic> item in apiResponse.result?.list as List) {
          data.add(Twitter.fromJson(item));
        }


        return ResponseModel<List<Twitter>>(
            success: true,
            type: ResponseType.success,
            result: data,
            cursorId: apiResponse.result?.nextCursor

        );
      } else {
        return ResponseModel(success: false, type: ResponseType.alert);
      }
    } catch (e) {
      return ResponseModel<List<Twitter>>(
        success: false,
        type: ResponseType.alert,
        title: 'x 정보 조회 실패',
      );
    }
  }
}
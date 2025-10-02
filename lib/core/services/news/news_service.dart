import 'package:intl/intl.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';

part 'news_service.g.dart';


@riverpod
class NewsService extends _$NewsService{

  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {}

  Future<ResponseModel<List<News>>> getMagazine(DateTime date) async {
    try {
      DateFormat format = DateFormat('yyyy-MM-dd');

      final response = await _apiService.get(
        url: '${ApiPath.apiUrl}v1/magazine',
        params: {"viewDate": format.format(date)},
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

        final List<News> data = [];
        for (final Map<String, dynamic> item in apiResponse.result?.list as List) {
          data.add(News.fromJson(item));
        }

        return ResponseModel<List<News>>(
          success: true,
          type: ResponseType.success,
          result: data
        );
      } else {
        return ResponseModel(success: false, type: ResponseType.alert);
      }
    } catch (err) {
      return ResponseModel(success: false, type: ResponseType.alert);
    }
  }

}
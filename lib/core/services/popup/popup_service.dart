import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:xrp_monitor/core/services/base/models/api_response.dart';
import 'package:xrp_monitor/core/services/popup/models/popup_model.dart';

part 'popup_service.g.dart';

@riverpod
class PopupService extends _$PopupService {
  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {}

  Future<List<PopupModel>> getActivePopups() async {
    final response = await _apiService.get(
      url: '${ApiPath.apiUrl}popup/active',
      isTokenLess: true,
    );
    final apiResponse = ApiResponse.fromJson(response.data!);
    return (apiResponse.result?.list as List<dynamic>? ?? [])
        .map((item) => PopupModel.fromJson(item as Map<String, dynamic>))
        .take(10)
        .toList();
  }
}

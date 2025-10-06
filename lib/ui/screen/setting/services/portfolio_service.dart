import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_exception.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/ui/screen/setting/models/portfolio_model.dart';

part 'portfolio_service.g.dart';


@riverpod
class PortfolioService extends _$PortfolioService{

  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {}

  Future<ResponseModel<Portfolio>> getPortfolio() async {
    try {
      final response = await _apiService.get(
        url: '${ApiPath.apiUrl}xrp/holding',
      );
      if (response.statusCode == 200) {
        print('response.data, ${response.data}');
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

        Portfolio? portfolio;
        print('(apiResponse.result ${apiResponse.result?.data}');
        if(apiResponse.result?.data != null){
          portfolio = Portfolio.fromJson(apiResponse.result!.data as Map<String, dynamic>);
        }else{
          portfolio = Portfolio(id: -1, quantity: '0', averagePrice: '0', totalInvested: '0', memo: '', createdAt: '', updatedAt: '');
        }

        return ResponseModel<Portfolio>(
            success: true,
            type: ResponseType.success,
            result: portfolio,
            cursorId: apiResponse.result?.nextCursor
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
            title: '포트폴리오 조회 실패',
          )
      );
    }
  }

  Future<ResponseModel<Portfolio>> editPortfolio(PortfolioRequest params) async {
    try {
      final response = await _apiService.post(
        url: '${ApiPath.apiUrl}xrp/holding',
        params: params.toJson()
      );
      if (response.statusCode == 201) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

        Portfolio? portfolio;
        print('(apiResponse.result ${apiResponse.result?.data}');
        if(apiResponse.result?.data != null){
          portfolio = Portfolio.fromJson(apiResponse.result!.data as Map<String, dynamic>);
        }else{
          portfolio = Portfolio(id: -1, quantity: '0', averagePrice: '0', totalInvested: '0', memo: '', createdAt: '', updatedAt: '');
        }

        print('portfolio ${portfolio}');

        return ResponseModel<Portfolio>(
            success: true,
            type: ResponseType.success,
            result: portfolio,
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
            title: '포트폴리오 조회 실패',
          )
      );
    }
  }

}
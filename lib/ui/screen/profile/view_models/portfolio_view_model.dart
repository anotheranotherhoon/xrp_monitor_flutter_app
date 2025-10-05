import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/core/services/news/news_service.dart';
import 'package:xrp_monitor/ui/screen/news/models/news_state.dart';
import 'package:xrp_monitor/ui/screen/profile/models/portfolio_model.dart';
import 'package:xrp_monitor/ui/screen/profile/services/portfolio_service.dart';

part 'portfolio_view_model.g.dart';



@riverpod
class PortfolioViewModel extends _$PortfolioViewModel {
  late final PortfolioService _portfolioService;

  @override
  FutureOr<PortfolioState> build() async {
    _portfolioService = ref.read(portfolioServiceProvider.notifier);
    return await fetchPortfolio();
  }


  Future<PortfolioState> fetchPortfolio() async {
    final ResponseModel<Portfolio> response = await _portfolioService.getPortfolio();
    return PortfolioState(
        portfolio: response.result ?? null,
    );
  }


  Future<void> editPortfolio({
    required String quantity,
    required String averagePrice,
    String? memo,
  }) async {
   try{
     print('🚀 editPortfolio 시작 - quantity: $quantity, averagePrice: $averagePrice, memo: $memo');
     
     final ResponseModel<Portfolio> response = await _portfolioService.editPortfolio(
         PortfolioRequest(
             quantity: double.parse(quantity),
             averagePrice: double.parse(averagePrice),
             memo: memo ?? ''
         )
     );

     print('📡 API 응답 - success: ${response.success}, result: ${response.result}');

     if (response.success && response.result != null) {
       state = AsyncValue.data(PortfolioState(
         portfolio: response.result,
       ));
       print('✅ 상태 업데이트 성공');
     } else {
       print('❌ API 응답 실패 - success: ${response.success}, result: ${response.result}');
       throw Exception('포트폴리오 수정에 실패했습니다. API 응답 오류');
     }
   } catch(e) {
     print('💥 에러 발생: $e');
     state = AsyncValue.error(e, StackTrace.current);
     rethrow;
   }
  }


}

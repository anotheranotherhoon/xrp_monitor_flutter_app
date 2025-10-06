import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/ui/screen/setting/models/portfolio_model.dart';
import 'package:xrp_monitor/ui/screen/setting/services/portfolio_service.dart';

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
     final ResponseModel<Portfolio> response = await _portfolioService.editPortfolio(
         PortfolioRequest(
             quantity: double.parse(quantity),
             averagePrice: double.parse(averagePrice),
             memo: memo ?? ''
         )
     );

     if (response.success && response.result != null) {
       state = AsyncValue.data(PortfolioState(
         portfolio: response.result,
       ));
     } else {
       throw Exception('포트폴리오 수정에 실패했습니다. API 응답 오류');
     }
   } catch(e) {
     state = AsyncValue.error(e, StackTrace.current);
     rethrow;
   }
  }


}

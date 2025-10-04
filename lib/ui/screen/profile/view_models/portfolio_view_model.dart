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
    return await _fetchPortfolio();
  }


  Future<PortfolioState> _fetchPortfolio() async {
    final ResponseModel<Portfolio> response = await _portfolioService.getNPortfolio();
    return PortfolioState(
        portfolio: response.result ?? null,
    );
  }


}

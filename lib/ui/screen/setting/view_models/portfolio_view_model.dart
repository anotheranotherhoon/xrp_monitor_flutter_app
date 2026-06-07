import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/services/base/models/response_model.dart';
import 'package:xrp_monitor/service/network/network_status_service.dart';
import 'package:xrp_monitor/service/storage/portfolio_local_database.dart';
import 'package:xrp_monitor/ui/screen/setting/models/portfolio_model.dart';
import 'package:xrp_monitor/ui/screen/setting/services/portfolio_service.dart';

part 'portfolio_view_model.g.dart';

@riverpod
class PortfolioViewModel extends _$PortfolioViewModel {
  late final PortfolioService _portfolioService;
  final PortfolioLocalDatabase _localDatabase = PortfolioLocalDatabase.instance;
  ProviderSubscription<bool>? _networkSubscription;
  bool _isSyncing = false;

  @override
  FutureOr<PortfolioState> build() async {
    _portfolioService = ref.read(portfolioServiceProvider.notifier);
    _networkSubscription = ref.listen<bool>(networkStatusProvider, (
      previous,
      isOnline,
    ) {
      if (isOnline && previous == false) {
        unawaited(syncPendingPortfolio());
      } else if (!isOnline) {
        _setOffline();
      }
    });
    ref.onDispose(() => _networkSubscription?.close());
    return await fetchPortfolio();
  }

  Future<PortfolioState> fetchPortfolio() async {
    final cachedPortfolio = await _localDatabase.getPortfolio();
    final pendingRequest = await _localDatabase.getPendingRequest();
    final lastUpdatedAt = await _localDatabase.getUpdatedAt();
    final isOnline = await ref.read(networkStatusProvider.notifier).checkNow();

    if (!isOnline) {
      return PortfolioState(
        portfolio: cachedPortfolio,
        isOffline: true,
        hasPendingSync: pendingRequest != null,
        lastUpdatedAt: lastUpdatedAt,
      );
    }

    if (pendingRequest != null) {
      final synced = await _syncRequest(pendingRequest);
      if (synced != null) {
        return PortfolioState(portfolio: synced, lastUpdatedAt: DateTime.now());
      }
      return PortfolioState(
        portfolio: cachedPortfolio,
        isOffline: true,
        hasPendingSync: true,
        lastUpdatedAt: lastUpdatedAt,
      );
    }

    try {
      final ResponseModel<Portfolio> response =
          await _portfolioService.getPortfolio();
      final portfolio = response.result;
      if (response.success && portfolio != null) {
        await _localDatabase.saveSyncedPortfolio(portfolio);
        return PortfolioState(
          portfolio: portfolio,
          lastUpdatedAt: DateTime.now(),
        );
      }
      throw Exception('포트폴리오 조회에 실패했습니다.');
    } catch (_) {
      if (cachedPortfolio != null) {
        return PortfolioState(
          portfolio: cachedPortfolio,
          isOffline: true,
          hasPendingSync: pendingRequest != null,
          lastUpdatedAt: lastUpdatedAt,
        );
      }
      rethrow;
    }
  }

  Future<void> editPortfolio({
    required String quantity,
    required String averagePrice,
    String? memo,
  }) async {
    final request = PortfolioRequest(
      quantity: double.parse(quantity),
      averagePrice: double.parse(averagePrice),
      memo: memo ?? '',
    );
    final current = state.value?.portfolio;
    final optimisticPortfolio = Portfolio(
      key: current?.key ?? -1,
      quantity: quantity,
      averagePrice: averagePrice,
      totalInvested: (request.quantity * request.averagePrice).toStringAsFixed(
        2,
      ),
      memo: request.memo,
      createdAt: current?.createdAt ?? '',
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _localDatabase.savePendingPortfolio(
      portfolio: optimisticPortfolio,
      request: request,
    );
    state = AsyncValue.data(
      PortfolioState(
        portfolio: optimisticPortfolio,
        isOffline: !ref.read(networkStatusProvider),
        hasPendingSync: true,
        lastUpdatedAt: DateTime.now(),
      ),
    );

    if (ref.read(networkStatusProvider)) {
      await syncPendingPortfolio();
    }
  }

  Future<void> syncPendingPortfolio() async {
    if (_isSyncing || !ref.read(networkStatusProvider)) return;
    final pendingRequest = await _localDatabase.getPendingRequest();
    if (pendingRequest == null) {
      await _refreshFromRemote();
      return;
    }

    _isSyncing = true;
    try {
      final synced = await _syncRequest(pendingRequest);
      if (synced != null) {
        state = AsyncValue.data(
          PortfolioState(portfolio: synced, lastUpdatedAt: DateTime.now()),
        );
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<Portfolio?> _syncRequest(PortfolioRequest request) async {
    try {
      final response = await _portfolioService.editPortfolio(request);
      final portfolio = response.result;
      if (response.success && portfolio != null) {
        await _localDatabase.saveSyncedPortfolio(portfolio);
        return portfolio;
      }
    } catch (_) {
      _setOffline(hasPendingSync: true);
    }
    return null;
  }

  Future<void> _refreshFromRemote() async {
    try {
      final response = await _portfolioService.getPortfolio();
      final portfolio = response.result;
      if (response.success && portfolio != null) {
        await _localDatabase.saveSyncedPortfolio(portfolio);
        state = AsyncValue.data(
          PortfolioState(portfolio: portfolio, lastUpdatedAt: DateTime.now()),
        );
        return;
      }
    } catch (_) {
      _setOffline();
      return;
    }
    _setOnline();
  }

  void _setOffline({bool? hasPendingSync}) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        isOffline: true,
        hasPendingSync: hasPendingSync ?? current.hasPendingSync,
      ),
    );
  }

  void _setOnline() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(isOffline: false, hasPendingSync: false),
    );
  }
}

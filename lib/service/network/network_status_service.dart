import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkStatusProvider =
    StateNotifierProvider<NetworkStatusNotifier, bool>((ref) {
      final notifier = NetworkStatusNotifier(Connectivity());
      ref.onDispose(notifier.dispose);
      return notifier;
    });

class NetworkStatusNotifier extends StateNotifier<bool> {
  NetworkStatusNotifier(this._connectivity) : super(true) {
    _initialize();
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _initialize() async {
    await checkNow();
    _subscription = _connectivity.onConnectivityChanged.listen(_update);
  }

  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    _update(results);
    return state;
  }

  void _update(List<ConnectivityResult> results) {
    state = results.any((result) => result != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

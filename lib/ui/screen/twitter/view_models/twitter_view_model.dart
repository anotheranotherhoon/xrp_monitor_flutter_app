import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/services/base/models/response_model.dart';
import 'package:xrp_monitor/core/services/twitter/models/twitter_model.dart';
import 'package:xrp_monitor/core/services/twitter/twitter_service.dart';
import 'package:xrp_monitor/ui/screen/twitter/models/twitter_state.dart';

part 'twitter_view_model.g.dart';

@riverpod
class TwitterViewModel extends _$TwitterViewModel {
  late final TwitterService _twitterService;

  @override
  FutureOr<TwitterState> build() async {
    _twitterService = ref.read(twitterServiceProvider.notifier);
    return await _fetchTweet('-1');
  }

  Future<TwitterState> _fetchTweet(String? cursorId) async {
    final ResponseModel<List<Twitter>> response = await _twitterService
        .getCryptoNews(cursorId: cursorId);
    return TwitterState(
      item: response.result ?? [],
      cursorId: response.cursorId,
    );
  }

  Future<void> getNextTweet() async {
    if (state.valueOrNull == null || state.value?.cursorId == null) {
      return;
    } else {
      try {
        state = AsyncData(state.value!.copyWith(isFetching: true));
        final TwitterState newState = await _fetchTweet(state.value?.cursorId);

        state = AsyncData(
          TwitterState(
            item: [...state.value!.item, ...newState.item],
            cursorId: newState.cursorId,
            isFetching: false,
          ),
        );
      } catch (err, stack) {
        log(err.toString(), stackTrace: stack);
        state = AsyncData(state.value!.copyWith(isFetching: false));
      }
    }
  }
}

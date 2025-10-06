import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/tweet/models/tweet_model.dart';
import 'package:xrp_monitor/core/services/tweet/tweet_service.dart';
import 'package:xrp_monitor/ui/screen/tweet/models/tweet_state.dart';


part 'tweet_view_model.g.dart';

@riverpod
class TweetViewModel extends _$TweetViewModel {
  late final TweetService _tweetService;

  @override
  FutureOr<TweetState> build() async {
    _tweetService = ref.read(tweetServiceProvider.notifier);
    return await _fetchTweet(null);
  }

  Future<TweetState> _fetchTweet(String? cursorId) async {
    final ResponseModel<List<Tweet>> response = await _tweetService.getTweetById(
        TweetIdParams(
          id: '25073877',
        )
    );
    return TweetState(
        item: response.result ?? [],
        cursorId:response.cursorId
    );
  }

  Future<void> getNextTweet() async{
    if (
    state.valueOrNull == null ||
        state.value?.cursorId == null
    ) {
      return;
    }else{
      try {
        state = AsyncData(state.value!.copyWith(isFetching: true));
        final TweetState newState = await _fetchTweet(
            state.value?.cursorId
        );

        state = AsyncData(
          TweetState(
            item: [...state.value!.item, ...newState.item],
            cursorId: newState.cursorId ?? null,
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
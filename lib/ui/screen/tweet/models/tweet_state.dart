import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/models/common/pagination.dart';
import 'package:xrp_monitor/core/services/tweet/models/tweet_model.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';

part 'tweet_state.freezed.dart';

@freezed
abstract class TweetState with _$TweetState {
  const factory TweetState({
    @Default([]) List<Tweet> item,
    @Default(false) bool isFetching,
    String? cursorId,
    Pagination? pageInfo,
  }) = _TweetState;
}
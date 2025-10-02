import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/models/common/pagination.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';

part 'youtube_state.freezed.dart';

@freezed
abstract class YoutubeState with _$YoutubeState {
  const factory YoutubeState({
    @Default([]) List<YoutubeVideo> item,
    @Default(false) bool isFetching,
    String? cursorId,
    Pagination? pageInfo,
  }) = _YoutubeState;
}
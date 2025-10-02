import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';
import 'package:xrp_monitor/core/services/youtube/youtube_service.dart';
import 'package:xrp_monitor/ui/screen/youtube/models/youtube_state.dart';

part 'youtube_view_model.g.dart';

@riverpod
class YoutubeViewModel extends _$YoutubeViewModel {
  late final YoutubeService _youtubeService;

  @override
  FutureOr<YoutubeState> build() async {
    _youtubeService = ref.read(youtubeServiceProvider.notifier);
    return await _fetchYoutubeVideos(null);
  }

  Future<YoutubeState> _fetchYoutubeVideos(String? cursorId) async {
    final ResponseModel<List<YoutubeVideo>> response = await _youtubeService.getYoutubeVideos(
      YoutubeCursorIdParams(
          q: '리플',
          cursorId: cursorId,
      )
    );
    return YoutubeState(
        item: response.result ?? [],
      cursorId: response.cursorId
    );
  }

  Future<void> getNextYoutubeVideos() async{
    if (
    state.valueOrNull == null ||
    state.value?.cursorId == null
    ) {
      return;
    }else{
      try {
        state = AsyncData(state.value!.copyWith(isFetching: true));
        final YoutubeState newState = await _fetchYoutubeVideos(
          state.value?.cursorId
        );

        state = AsyncData(
          YoutubeState(
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
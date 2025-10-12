import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/services/base/models/response_model.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/core/services/news/news_service.dart';
import 'package:xrp_monitor/ui/screen/news/models/news_state.dart';

part 'news_view_model.g.dart';



@riverpod
class NewsViewModel extends _$NewsViewModel {
  late final NewsService _newsService;

  @override
  FutureOr<NewsState> build() async {
    _newsService = ref.read(newsServiceProvider.notifier);
    return await _fetchNews(-1);
  }


  Future<NewsState> _fetchNews(int? cursorId) async {
    final ResponseModel<List<News>> response = await _newsService.getNews(
      NewsCursorIdParams(cursorId: cursorId)
    );
    return NewsState(
        item: response.result ?? [],
      cursorId: response.cursorId
    );
  }

  Future<void> getNextNews() async{
    if (
    state.valueOrNull == null ||
    state.value?.cursorId == null
    ) {
      return;
    }else{
      try {
        state = AsyncData(state.value!.copyWith(isFetching: true));
        final NewsState newState = await _fetchNews(
          state.value?.cursorId
        );

        state = AsyncData(
          NewsState(
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

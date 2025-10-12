import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/services/base/models/pagination.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';


part 'news_state.freezed.dart';

@freezed
abstract class NewsState with _$NewsState {
  const factory NewsState({
    @Default([]) List<News> item,
    @Default(false) bool isFetching,
    int? cursorId,
    Pagination? pageInfo,
  }) = _NewsState;
}
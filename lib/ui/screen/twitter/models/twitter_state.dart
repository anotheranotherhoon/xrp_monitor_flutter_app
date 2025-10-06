import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/models/common/pagination.dart';
import 'package:xrp_monitor/core/services/twitter/models/twitter_model.dart';

part 'twitter_state.freezed.dart';

@freezed
abstract class TwitterState with _$TwitterState {
  const factory TwitterState({
    @Default([]) List<Twitter> item,
    @Default(false) bool isFetching,
    String? cursorId,
    Pagination? pageInfo,
  }) = _TwitterState;
}
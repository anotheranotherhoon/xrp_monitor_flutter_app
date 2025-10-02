// ignore_for_file: invalid_annotation_target
import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';

// import 'package:flutter_open_search/core/models/common/file_model.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class News with _$News {
  const factory News({
    @JsonKey(name: 'neTitle') @Default('') String title,
    @JsonKey(name: 'neOriginalLink') @Default('') String originalLink,
    @JsonKey(name: 'neLink') @Default('') String link,
    @JsonKey(name: 'neDescription') @Default('') String description,
    @JsonKey(name: 'neCreatedAt') @Default('') String createdAt,
  }) = _News;

const News._();

factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

}

@JsonSerializable(includeIfNull: false)
class NewsCursorIdParams {
  NewsCursorIdParams({
    required this.cursorId,
  });

  factory NewsCursorIdParams.fromJson(Map<String, dynamic> json) => _$NewsCursorIdParamsFromJson(json);

  final int? cursorId;
  Map<String, dynamic> toJson() => _$NewsCursorIdParamsToJson(this);
}
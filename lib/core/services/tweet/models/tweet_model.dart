// ignore_for_file: invalid_annotation_target
import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet_model.freezed.dart';
part 'tweet_model.g.dart';

@freezed
abstract class Tweet with _$Tweet {
  const factory Tweet({
    @JsonKey(name: 'twId') @Default('') String id,
    @JsonKey(name: 'twText') @Default('') String text,
    @JsonKey(name: 'twCreatedAt') @Default('') String createdAt,
    @JsonKey(name: 'twAuthorId') @Default('') String authorId,
    @JsonKey(name: 'twLang') @Default('') String lang,

  }) = _Tweet;

  const Tweet._();

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

}



@JsonSerializable(includeIfNull: false)
class TweetIdParams {
  TweetIdParams({
    required this.id
  });

  factory TweetIdParams.fromJson(Map<String, dynamic> json) => _$TweetIdParamsFromJson(json);

  final String id;
  Map<String, dynamic> toJson() => _$TweetIdParamsToJson(this);
}
// ignore_for_file: invalid_annotation_target
import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'youtube_model.freezed.dart';
part 'youtube_model.g.dart';

@freezed
abstract class YoutubeVideo with _$YoutubeVideo {
  const factory YoutubeVideo({
    @JsonKey(name: 'yoTitle') @Default('') String title,
    @JsonKey(name: 'yoDescription') @Default('') String description,
    @JsonKey(name: 'yoChannelTitle') @Default('') String channelName,
    @JsonKey(name: 'yoCreatedAt') @Default('') String createdAt,
    @JsonKey(name: 'ytChannelId') @Default('') String originalLink,
    @JsonKey(name: 'yoVideoId') @Default('') String videoId,
    @JsonKey(name: 'thumbnails') YoutubeThumbnails? thumbnails,
  }) = _YoutubeVideo;

const YoutubeVideo._();

factory YoutubeVideo.fromJson(Map<String, dynamic> json) => _$YoutubeVideoFromJson(json);

}

@freezed
abstract class YoutubeThumbnails with _$YoutubeThumbnails {
  const factory YoutubeThumbnails({
    @JsonKey(name: 'default') YoutubeThumbnailItem? defaultThumbnail,
    YoutubeThumbnailItem? medium,
    YoutubeThumbnailItem? high,
  }) = _YoutubeThumbnails;

  factory YoutubeThumbnails.fromJson(Map<String, dynamic> json) => _$YoutubeThumbnailsFromJson(json);
}

@freezed
abstract class YoutubeThumbnailItem with _$YoutubeThumbnailItem {
  const factory YoutubeThumbnailItem({
    @Default('') String url,
    @Default(0) int width,
    @Default(0) int height,
  }) = _YoutubeThumbnailItem;

  factory YoutubeThumbnailItem.fromJson(Map<String, dynamic> json) => _$YoutubeThumbnailItemFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class YoutubeCursorIdParams {
  YoutubeCursorIdParams({
    required this.cursorId,
    required this.q
  });

  factory YoutubeCursorIdParams.fromJson(Map<String, dynamic> json) => _$YoutubeCursorIdParamsFromJson(json);

  final String? cursorId;
  final String q;
  Map<String, dynamic> toJson() => _$YoutubeCursorIdParamsToJson(this);
}
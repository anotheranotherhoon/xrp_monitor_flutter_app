// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'twitter_model.freezed.dart';
part 'twitter_model.g.dart';

@freezed
abstract class Twitter with _$Twitter {
  const factory Twitter({
    @JsonKey(name: 'twId') @Default('') String id,
    @JsonKey(name: 'twText') @Default('') String text,
    @JsonKey(name: 'twCreatedAt') @Default('') String createdAt,
    @JsonKey(name: 'twAuthorId') @Default('') String authorId,
    @JsonKey(name: 'twLang') @Default('') String lang,
  }) = _Twitter;

  const Twitter._();

  factory Twitter.fromJson(Map<String, dynamic> json) =>
      _$TwitterFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class TwitterIdParams {
  TwitterIdParams({required this.id, this.cursorId, this.perPage = 10});

  factory TwitterIdParams.fromJson(Map<String, dynamic> json) =>
      _$TwitterIdParamsFromJson(json);

  final String id;
  final String? cursorId;
  final int perPage;
  Map<String, dynamic> toJson() => _$TwitterIdParamsToJson(this);
}

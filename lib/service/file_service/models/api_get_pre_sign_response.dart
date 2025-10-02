// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'attachment_info.dart';


part 'api_get_pre_sign_response.freezed.dart';
part 'api_get_pre_sign_response.g.dart';

@freezed
abstract class ApiGetPreSignResponseBody with _$ApiGetPreSignResponseBody {
  const factory ApiGetPreSignResponseBody({
    @JsonKey(name: 'presignedUrl') @Default('') String presignedUrl,
    @JsonKey(name: 'attachmentInfo') @Default(null) AttachmentInfo? attachmentInfo,
  }) = _ApiGetPreSignResponseBody;

  const ApiGetPreSignResponseBody._();

  factory ApiGetPreSignResponseBody.fromJson(Map<String, dynamic> json) =>
      _$ApiGetPreSignResponseBodyFromJson(json);
}

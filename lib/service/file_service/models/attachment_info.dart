// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_info.freezed.dart';
part 'attachment_info.g.dart';

@freezed
abstract class AttachmentInfo with _$AttachmentInfo {
  const factory AttachmentInfo({
    @JsonKey(name: 'atIdx') @Default(0) int id,
    @JsonKey(name: 'ownerIdx') @Default(0) int ownerIdx,
    @JsonKey(name: 'atType') @Default('') String atType,
    @JsonKey(name: 'atFileName') @Default('') String atFileName,
    @JsonKey(name: 'atUrl') @Default('') String atUrl,
    @JsonKey(name: 'atContentType') @Default('') String atContentType,
    @JsonKey(name: 'atUuid') @Default('') String atUuid,
  }) = _AttachmentInfo;

  factory AttachmentInfo.fromJson(Map<String, dynamic> json) => _$AttachmentInfoFromJson(json);
  static AttachmentInfo empty() =>
      const AttachmentInfo(id: 0, atType: '', atFileName: '', atUrl: '', atContentType: '');
}

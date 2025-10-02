// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_file.freezed.dart';
part 'attachment_file.g.dart';

@freezed
abstract class AttachmentFile with _$AttachmentFile {
  const factory AttachmentFile({
    @JsonKey(name: 'atIdx')
    required int id,
    @JsonKey(name: 'atUrl')
    required String url,
    @JsonKey(name: 'atFileName')
    required String name,
    @JsonKey(name: 'atType')
    required String type,
    @JsonKey(name: 'mime')
    required String mime,
    @Default(false)
    bool uploadFile,
  }) = _AttachmentFile;

  const AttachmentFile._();

  factory AttachmentFile.fromJson(Map<String, dynamic> json) => _$AttachmentFileFromJson(json);
}
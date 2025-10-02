// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import '../api_template/file_api_request.dart';

part 'file_delete.freezed.dart';
part 'file_delete.g.dart';

@freezed
class FileDeleteV1 with _$FileDeleteV1, FileApiRequest {
  @With<FileApiRequest>()

  const factory FileDeleteV1({
    @JsonKey(name: 'atIdx') required int atIdx,
  }) = _FileDeleteV1;

  factory FileDeleteV1.fromJson(Map<String, dynamic> json) => _$FileDeleteV1FromJson(json);

  const FileDeleteV1._();

  @override
  FileRequestOptions get requestMetadata =>
      FileRequestOptions(path: 'v1/attachment/delete/$atIdx', method: Method.delete);

  @override
  // TODO: implement atIdx
  int get atIdx => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
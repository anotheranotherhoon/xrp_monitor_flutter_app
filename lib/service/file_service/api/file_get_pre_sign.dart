// ignore_for_file: invalid_annotation_target
import 'package:xrp_monitor/service/file_service/api_template/file_api_request.dart';
import 'package:xrp_monitor/service/file_service/models/api_get_pre_sign_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'file_get_pre_sign.freezed.dart';
part 'file_get_pre_sign.g.dart';

@freezed
class FileGetPreSignRequestV1 with _$FileGetPreSignRequestV1, FileApiRequest {
  @With<FileApiRequest>()
  const factory FileGetPreSignRequestV1({
    @JsonKey(name: 'params') required ApiGetPreSignParams params,
  }) = _FileGetPreSignRequestV1;

  factory FileGetPreSignRequestV1.fromJson(Map<String, dynamic> json) => _$FileGetPreSignRequestV1FromJson(json);

  const FileGetPreSignRequestV1._();

  @override
  FileRequestOptions get requestMetadata =>
      FileRequestOptions(path: 'v1/attachment', method: Method.post, body: params.toJson());

  @override
  // TODO: implement params
  ApiGetPreSignParams get params => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
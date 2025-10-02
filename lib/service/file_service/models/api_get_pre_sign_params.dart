// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_get_pre_sign_params.g.dart';

@JsonSerializable(includeIfNull: false)
class ApiGetPreSignParams {
  ApiGetPreSignParams({
    required this.containerType,
    required this.ownerIdx,
    required this.contentType,
    required this.fileName,

  });
  String containerType;
  int ownerIdx;
  String contentType;
  String fileName;

  factory ApiGetPreSignParams.fromJson(Map<String, dynamic> json) => _$ApiGetPreSignParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiGetPreSignParamsToJson(this);
}
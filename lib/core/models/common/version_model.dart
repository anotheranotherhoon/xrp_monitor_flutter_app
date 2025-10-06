// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
abstract class VersionModel with _$VersionModel {
  const factory VersionModel({
    @JsonKey(name: 'version') @Default('') String version,
    @JsonKey(name: 'platform') @Default('') String platform,
    @JsonKey(name: 'minimumVersion') @Default('') String minimumVersion,
    @JsonKey(name: 'appStatus') @Default(1) int appStatus,
    @JsonKey(name: 'releaseNotes') @Default([]) List<String> releaseNotes,
    @JsonKey(name: 'downloadUrl') @Default('') String downloadUrl,
    @JsonKey(name: 'apiDomain') @Default('') String apiDomain,
  }) = _VersionModel;

  const VersionModel._();

  factory VersionModel.fromJson(Map<String, dynamic> json) => _$VersionModelFromJson(json);
}
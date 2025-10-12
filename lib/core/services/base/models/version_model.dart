// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
abstract class Version with _$Version {
  const factory Version({
    @JsonKey(name: 'veVersion') @Default('') String version,
    @JsonKey(name: 'vePlatform') @Default('') String platform,
    @JsonKey(name: 'veMinimumVersion') @Default('') String minimumVersion,
    @JsonKey(name: 'veAppStatus') @Default(1) int appStatus,
    @JsonKey(name: 'veReleaseNotes') @Default([]) List<String> releaseNotes,
    @JsonKey(name: 'veDownloadUrl') @Default('') String downloadUrl,
    @JsonKey(name: 'veApiDomain') @Default('') String apiDomain,
  }) = _Version;

  const Version._();

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);
}
import 'package:xrp_monitor/core/services/base/api_constants.dart';

class CheckVersionModel {
  late final String apiDomain;
  late final String releaseNote;
  late final String lastVersion;
  late final int type;

  CheckVersionModel({
    required this.apiDomain,
    required this.releaseNote,
    required this.type,
  });

  CheckVersionModel.fromApiJson(Map<String, dynamic> json) {
    apiDomain = json['veUrl'] ?? ApiConstants.apiDomain;
    releaseNote = json['veReleaseNote'] ?? '';
    lastVersion = json['veLatestVersion'] ?? '';
    type = json['type'] ?? -1;
  }

  @override
  String toString() =>
      'CheckVersionModel(apiDomain: $apiDomain, releaseNote: $releaseNote, type: $type)';
}

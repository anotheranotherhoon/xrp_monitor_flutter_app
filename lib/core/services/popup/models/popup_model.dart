// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';

part 'popup_model.freezed.dart';
part 'popup_model.g.dart';

enum PopupActionType {
  @JsonValue('NONE')
  none,
  @JsonValue('EXTERNAL_LINK')
  externalLink,
}

@freezed
abstract class PopupModel with _$PopupModel {
  const factory PopupModel({
    @JsonKey(name: 'poIdx') @Default(0) int key,
    @JsonKey(name: 'poTitle') @Default('') String title,
    @JsonKey(name: 'poImageUrl') @Default('') String imageUrl,
    @JsonKey(name: 'poDisplayOrder') @Default(1) int displayOrder,
    @JsonKey(name: 'poEndAt') String? endAt,
    @JsonKey(name: 'poActionType')
    @Default(PopupActionType.none)
    PopupActionType actionType,
    @JsonKey(name: 'poLinkUrl') String? linkUrl,
  }) = _PopupModel;

  const PopupModel._();

  String get resolvedImageUrl =>
      imageUrl.startsWith('http') ? imageUrl : '${ApiPath.apiDomain}$imageUrl';

  DateTime? get localEndAt => DateTime.tryParse(endAt ?? '')?.toLocal();

  bool get hasExternalLink {
    final Uri? uri = Uri.tryParse(linkUrl ?? '');
    return actionType == PopupActionType.externalLink &&
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  factory PopupModel.fromJson(Map<String, dynamic> json) =>
      _$PopupModelFromJson(json);
}

// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_user_info_model.freezed.dart';

part 'social_user_info_model.g.dart';

enum MemberType { KAKAO, APPLE, GOOGLE, NONE }

enum YesNoType { YES, NO }

@freezed
abstract class SocialUserInfo with _$SocialUserInfo {
  const factory SocialUserInfo({
    @JsonKey(name: 'meIdx') required int id,
    @JsonKey(name: 'meNickname') @Default('') String nickname,
    @JsonKey(name: 'msiMemberSocialType', unknownEnumValue: MemberType.NONE) required MemberType memberType,
    @JsonKey(name: 'meEmail') @Default('') String email,
    @JsonKey(name: 'meIsValid', unknownEnumValue: YesNoType.NO) required YesNoType meIsValid,
    @JsonKey(name: 'msiEmail') @Default('') String socialEmail,
    @JsonKey(name: 'msiNickname') @Default('') String socialNickname,
    DateTime? createdAt,
  }) = _SocialUserInfo;

  const SocialUserInfo._();

  factory SocialUserInfo.fromJson(Map<String, dynamic> json) => _$SocialUserInfoFromJson(json);

  static SocialUserInfo createDefault() {
    return SocialUserInfo(
      id: 0,
      nickname: '',
      memberType: MemberType.NONE,
      email: '',
      meIsValid: YesNoType.NO,
      createdAt: DateTime.now(),
    );
  }
}
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/constants/enums.dart';
import 'package:xrp_monitor/service/file_service/models/attachment_info.dart';

part 'user_info_model.freezed.dart';

part 'user_info_model.g.dart';




@freezed
abstract class UserInfo with _$UserInfo {
  const factory UserInfo({
    @JsonKey(name: 'meIdx') required int id,
    @JsonKey(name: 'meNickname') required String nickname,
    @JsonKey(name: 'msiMemberSocialType', unknownEnumValue: MemberType.NONE) required MemberType memberType,
    @JsonKey(name: 'meEmail') required String email,
    @JsonKey(name: 'meGender', unknownEnumValue: Gender.OTHER) required Gender gender,
    @JsonKey(name: 'meIsValid', fromJson: yesNoFromString) required YesNo meIsValid,
    @JsonKey(name: 'meBirthDate') required String birthDate,
    @JsonKey(name: 'mePhoneNumber') required String phoneNumber,
    @JsonKey(name: 'meRecommendCode') required String recommendCode,
    @JsonKey(name: 'matAgreeToPrivacyPolicy', fromJson: yesNoFromString) required YesNo agreePrivacy,
    @JsonKey(name: 'matAgreeToServiceTerms', fromJson: yesNoFromString) required YesNo agreeService,
    @JsonKey(name: 'matAgreeToMarketingInfo', fromJson: yesNoFromString) required YesNo agreeMarketing,
    @JsonKey(name: 'matAgreeToNightMarketingInfo', fromJson: yesNoFromString)
    required YesNo agreeNightMarketing,
    @JsonKey(name: 'matIsOverFourteen', fromJson: yesNoFromString) required YesNo isOverFourteen,
    @JsonKey(name: 'attachmentInfo') AttachmentInfo? attachmentInfo,
    DateTime? createdAt,
  }) = _UserInfo;

  const UserInfo._();

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  static UserInfo createDefault() {
    return UserInfo(
      id: 0,
      nickname: '',
      memberType: MemberType.NONE,
      email: '',
      gender: Gender.OTHER,
      meIsValid: YesNo.no,
      birthDate: '',
      phoneNumber: '',
      recommendCode: '',
      agreePrivacy: YesNo.no,
      agreeService: YesNo.no,
      agreeMarketing: YesNo.no,
      agreeNightMarketing: YesNo.no,
      isOverFourteen: YesNo.no,
      attachmentInfo: AttachmentInfo.empty(),
      createdAt: DateTime.now(),
    );
  }
}


@freezed
abstract class EnvValue with _$EnvValue {
  const factory EnvValue({
    @JsonKey(name: 'spotRadius') required int spotRadius,
    @JsonKey(name: 'dailyGoldThreshold') required int dailyGoldThreshold,
    @JsonKey(name: 'spotRewardMultiplier') required int spotRewardMultiplier,
    @JsonKey(name: 'popRewardMultiplier') required int popRewardMultiplier,
    @JsonKey(name: 'goldGrantDivider') required int goldGrantDivider,
    @JsonKey(name: 'autoPauseCreditMultiplier') required int autoPauseCreditMultiplier,
    DateTime? createdAt,
  }) = _EnvValue;

  const EnvValue._();

  factory EnvValue.fromJson(Map<String, dynamic> json) => _$EnvValueFromJson(json);

  static EnvValue createDefault() {
    return EnvValue(
        spotRadius: 0,
        dailyGoldThreshold: 0,
        spotRewardMultiplier: 0,
        popRewardMultiplier: 0,
        goldGrantDivider: 0,
        autoPauseCreditMultiplier: 0
    );
  }

}


@JsonSerializable(includeIfNull: false)
class EmailChangeParams {
  EmailChangeParams({required this.email, required this.certCode});

  factory EmailChangeParams.fromJson(Map<String, dynamic> json) => _$EmailChangeParamsFromJson(json);

  @JsonKey(name: 'verifiedEmail')
  final String email;
  @JsonKey(name: 'verifiedCode')
  final String certCode;

  Map<String, dynamic> toJson() => _$EmailChangeParamsToJson(this);
}

@JsonSerializable(includeIfNull: false)
class PasswordParams {
  PasswordParams({
    required this.password,
    required this.email,
    required this.code,
  });

  factory PasswordParams.fromJson(Map<String, dynamic> json) => _$PasswordParamsFromJson(json);

  @JsonKey(name: 'newPassword')
  final String password;
  @JsonKey(name: 'verifiedEmail')
  final String email;
  @JsonKey(name: 'verifiedCode')
  final String code;

  Map<String, dynamic> toJson() => _$PasswordParamsToJson(this);
}

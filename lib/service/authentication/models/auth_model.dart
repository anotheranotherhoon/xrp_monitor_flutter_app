// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.g.dart';
part 'auth_model.freezed.dart';



@JsonSerializable(includeIfNull: false)
class SendCertParams {
  SendCertParams({
    required this.targetEmail,
    required this.certPurpose,
  });
  factory SendCertParams.fromJson(Map<String, dynamic> json) => _$SendCertParamsFromJson(json);


  final String targetEmail;
  final String certPurpose;
  Map<String, dynamic> toJson() => _$SendCertParamsToJson(this);
}

@JsonSerializable(includeIfNull: false)
class VerifyCertParams {
  VerifyCertParams({
    required this.email,
    required this.certCode,
    required this.certPurpose,
  });
  factory VerifyCertParams.fromJson(Map<String, dynamic> json) => _$VerifyCertParamsFromJson(json);


  final String email;
  final String certCode;
  final String certPurpose;
  Map<String, dynamic> toJson() => _$VerifyCertParamsToJson(this);
}

@freezed
abstract class SignUpResult with _$SignUpResult {
  const factory SignUpResult({
    @JsonKey(name: 'meIdx') @Default(-1) int meIdx,
    @JsonKey(name: 'rewardReceiveInfo', fromJson: RewardReceiveInfo.fromJson) required RewardReceiveInfo rewardReceiveInfo,
    @JsonKey(name: 'jwtTokenResponse', fromJson: JwtTokenResponse.fromJson) required JwtTokenResponse jwtTokenResponse,

  }) = _SignUpResult;

  const SignUpResult._();

  factory SignUpResult.fromJson(Map<String, dynamic> json) => _$SignUpResultFromJson(json);
}

@freezed
abstract class RewardReceiveInfo with _$RewardReceiveInfo {
  const factory RewardReceiveInfo({
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(name: 'message') @Default('') String message,

  }) = _RewardReceiveInfo;

  const RewardReceiveInfo._();

  factory RewardReceiveInfo.fromJson(Map<String, dynamic> json) => _$RewardReceiveInfoFromJson(json);
}

@freezed
abstract class JwtTokenResponse with _$JwtTokenResponse {
  const factory JwtTokenResponse({
    @JsonKey(name: 'tokenType') @Default('') String tokenType,
    @JsonKey(name: 'accessToken') @Default('') String accessToken,
    @JsonKey(name: 'refreshToken') @Default('') String refreshToken,

  }) = _JwtTokenResponse;

  const JwtTokenResponse._();

  factory JwtTokenResponse.fromJson(Map<String, dynamic> json) => _$JwtTokenResponseFromJson(json);
}



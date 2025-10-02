import 'package:xrp_monitor/service/authentication/models/user_info_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/models/api/authentication/token.dart';
import 'package:xrp_monitor/service/authentication/models/social_user_info_model.dart';


part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    Token? accessToken,
    Token? refreshToken,
    UserInfo? user,
    SocialUserInfo? socialUser,
    EnvValue? envValue
  }) = _Session;

  const Session._();
}

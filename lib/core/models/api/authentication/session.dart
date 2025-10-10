import 'package:xrp_monitor/service/authentication/models/auth_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor/core/models/api/authentication/token.dart';


part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    Token? accessToken,
    Token? refreshToken,
    LoginUser? user,
  }) = _Session;

  const Session._();
}


import 'dart:developer';
import 'dart:io';

import 'package:xrp_monitor/core/models/api/authentication/session.dart';
import 'package:xrp_monitor/core/models/api/authentication/token.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_constants.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:xrp_monitor/core/services/session/session_service.dart';
import 'package:xrp_monitor/core/services/session/token_service.dart';
import 'package:xrp_monitor/service/authentication/models/user_info_model.dart';
import 'package:xrp_monitor/service/storage/local_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mutex/mutex.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/social_user_info_model.dart';


part 'authentication.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  static late final Authentication instance;
  late final SessionService _sessionService;
  final _lock = Mutex();
  late final tokenServiceProvider;
  @override
  Future<Session?> build() async {
    instance = this;
    tokenServiceProvider = Provider<TokenService>((ref) {
      final ApiService apiService = ref.watch(apiServiceProvider.notifier);
      return TokenService(apiService);
    });
    _sessionService = ref.watch(sessionServiceProvider.notifier);
    final String? accessToken = LocalStorageService.instance.getAccessToken();
    final String? refreshToken = LocalStorageService.instance.getRefreshToken();

    if (accessToken == null) {
      return null;
    }
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    if(decodedToken["role"] == "ROLE_USER_NOT_VALID") {
      LocalStorageService.instance.removeAllToken();
      return null;
    }

    final UserInfo user = await getMyInfo();

    final session = Session(
      accessToken: Token(
        token: accessToken,
        expiredAt: DateTime.now().add(const Duration(hours: 3)),
      ),
      refreshToken: refreshToken != null ? Token(
        token: refreshToken,
        expiredAt: DateTime.now().add(const Duration(days: 30)),
      ) : null,
      user: user,
      socialUser: null,
    );
    setMyToken(user);

    // state = AsyncValue.data(session);

    return session;
  }

  Future<Session?> updateSessionUserInfo() async {
    return _lock.protect(() async {
      final UserInfo user = await getMyInfo();
      final EnvValue envValue = await getEnvInfo();
      final String? accessToken = LocalStorageService.instance.getAccessToken();
      final String? refreshToken = LocalStorageService.instance.getRefreshToken();
      if (accessToken == null) {
        return null;
      }

      final session = Session(
          accessToken: Token(
            token: accessToken,
            expiredAt: DateTime.now().add(const Duration(hours: 3)),
          ),
          refreshToken: refreshToken != null ? Token(
            token: refreshToken,
            expiredAt: DateTime.now().add(const Duration(days: 30)),
          ) : null,
          user: user,
          envValue: envValue
      );
      state = AsyncValue.data(session);
      return session;
    });
  }

  Future<UserInfo> getMyInfo() async {
    final ResponseModel<dynamic> response = await _sessionService.getMyInfo();
    if (!response.success) {
      return UserInfo.createDefault();
    }
    final json = response.result.data as Map<String, dynamic>;
    final UserInfo userInfo = UserInfo.fromJson(json);
    setMyToken(userInfo);
    return userInfo;
  }

  Future<EnvValue> getEnvInfo() async {
    final ResponseModel<dynamic> response = await _sessionService.getEnvInfo();
    if (!response.success) {
      return EnvValue.createDefault();
    }
    final json = response.result.data as Map<String, dynamic>;
    final envValue = EnvValue.fromJson(json);
    return envValue;
  }

  setMyToken(my) async {
    // TokenService tokenService = TokenService();
    String deviceType;
    if (Platform.isIOS) {
      deviceType = ApiConstants.ios;
    } else {
      deviceType = ApiConstants.aos;
    }

    final tokenService = ref.read(tokenServiceProvider);
    tokenService.writeToken(deviceType);
  }
  //#region Sign in
  Future<UserInfo?> singInAfter(String token, String refreshToken) async {
    await LocalStorageService.instance.setUserToken(token);
    await LocalStorageService.instance.setUserRefreshToken(refreshToken);
    UserInfo user = UserInfo.createDefault();
    late Session session;
    user = await getMyInfo();
    EnvValue envValue = await getEnvInfo();
    session = Session(
        accessToken: Token(
          token: token,
          expiredAt: DateTime.now().add(const Duration(hours: 48)
          ),
        ),
        refreshToken: Token(
          token: refreshToken,
          expiredAt: DateTime.now().add(const Duration(days: 30)
          ),
        ),
        user:user,
        envValue: envValue
    );
    setMyToken(user);
    state = AsyncValue.data(session);
    return user;
  }

  Future<SocialUserInfo> getSocialUserInfoInfo() async {
    final ResponseModel<dynamic> response = await _sessionService.getMyInfo();
    if (!response.success) {
      return SocialUserInfo.createDefault();
    }
    final json = response.result.data as Map<String, dynamic>;
    final my = SocialUserInfo.fromJson(json);
    return my;
  }

  Future<SocialUserInfo?> signSocialAfter(String token, String refreshToken) async {
    await LocalStorageService.instance.setUserToken(token);
    SocialUserInfo user = SocialUserInfo.createDefault();
    late Session session;
    user = await getSocialUserInfoInfo();
    EnvValue envValue = await getEnvInfo();
    session = Session(
        accessToken: Token(
          token: token,
          expiredAt: DateTime.now().add(const Duration(hours: 48)),
        ),
        refreshToken: Token(
          token: refreshToken,
          expiredAt: DateTime.now().add(const Duration(days: 30)),
        ),
        user: null,
        socialUser: user,
        envValue: envValue
    );
    setMyToken(user);
    state = AsyncValue.data(session);
    return user;
  }

  Future<void> setToken(String token, String refreshToken) async {
    await LocalStorageService.instance.setUserToken(token);
    late Session session;
    session = Session(
      accessToken: Token(
        token: token,
        expiredAt: DateTime.now().add(const Duration(hours: 48)),
      ),
      refreshToken: Token(
        token: refreshToken,
        expiredAt: DateTime.now().add(const Duration(days: 30)),
      ),
      user:null,
    );
    state = AsyncValue.data(session);
  }

  void updateToken(String newAccessToken, String newRefreshToken) {
    final Token accessToken = Token(
      token: newAccessToken,
      expiredAt: DateTime.now().add(const Duration(hours: 48)),
    );
    final Token refreshToken = Token(
      token: newRefreshToken,
      expiredAt: DateTime.now().add(const Duration(hours: 48)),
    );
    state = state.whenData(
          (session) => session?.copyWith(
        accessToken: accessToken, refreshToken: refreshToken,),
    );
  }


  Future<Session?> setSession() async {
    try {

      final String? accessToken = LocalStorageService.instance.getAccessToken();
      final String? refreshToken = LocalStorageService.instance.getRefreshToken();
      if (accessToken == null) {
        return null;
      }
      final UserInfo user = await getMyInfo();
      final session = Session(
          accessToken: Token(
            token: accessToken,
            expiredAt: DateTime.now().add(const Duration(hours: 3)),
          ),
          refreshToken: refreshToken != null ? Token(
            token: refreshToken,
            expiredAt: DateTime.now().add(const Duration(days: 30)),
          ) : null,
          user: user
      );
      return session;
    } catch (err, stack) {
      await LocalStorageService.instance.removeAllToken();
      log(err.toString(), stackTrace: stack);
    }
    return null;
  }


  Future<void> fetch() async {
    state = const AsyncLoading();
    try {
      final data = await setSession();
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void removeSession() {
    LocalStorageService.instance.removeAllToken();
    state = const AsyncValue.data(null);
  }

  //TODO 0820 지울것
  void removeAccessSession() {
    LocalStorageService.instance.removeAccessToken();
    state = state.whenData(
          (session) => session?.copyWith(accessToken: null),
    );
  }

  //TODO 0820 지울것
  void removeRefreshSession() {
    LocalStorageService.instance.removeRefreshToken();
    state = state.whenData(
          (session) => session?.copyWith(refreshToken: null),
    );
  }



  Future<void> reloadWithEnv() async {
    final current = state.value;
    if (current == null) return;

    if (current.envValue == null) {
      final envValue = await getEnvInfo();
      state = AsyncData(current.copyWith(envValue: envValue));
    }
  }


}

import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, release }

class ApiPath {
  static const AppEnvironment environment =
      kReleaseMode ? AppEnvironment.release : AppEnvironment.dev;
  static const bool isDev = environment == AppEnvironment.dev;

  static const String prodDomain = 'https://xrp-monitor.p-e.kr';
  static const String prodWsDomain = 'wss://xrp-monitor.p-e.kr';

  static String get devDomain =>
      defaultTargetPlatform == TargetPlatform.android
          ? 'http://localhost:3000'
          : 'http://localhost:3000';

  static String get devWsDomain =>
      defaultTargetPlatform == TargetPlatform.android
          ? 'ws://localhost:3000'
          : 'ws://localhost:3000';

  static String get apiDomain => isDev ? devDomain : prodDomain;

  static String get wsDomain => isDev ? devWsDomain : prodWsDomain;

  static String get apiUrl => '$apiDomain/';

  static String get wsUrl => '$wsDomain/';
}

enum ServerType { dev, beta, prod }

class ApiPath {
  static const String devDomain = 'https://xrp-monitor.p-e.kr';
  static const String betaDomain = 'https://xrp-monitor.p-e.kr';
  static const String prodDomain = 'https://xrp-monitor.p-e.kr';

  static String devWsUrl = 'wss://xrp-monitor.p-e.kr';
  static String betaWsUrl = 'wss://xrp-monitor.p-e.kr';
  static String prodWsUrl = 'wss://xrp-monitor.p-e.kr';

  static ServerType currentServer = ServerType.dev;

  static String get apiDomain {
    switch (currentServer) {
      case ServerType.prod:
        return ApiPath.prodDomain;
      case ServerType.beta:
        return ApiPath.betaDomain;
      case ServerType.dev:
        return ApiPath.devDomain;
    }
  }

  static String get wsDomain {
    switch (currentServer) {
      case ServerType.prod:
        return ApiPath.prodWsUrl;
      case ServerType.beta:
        return ApiPath.betaWsUrl;
      case ServerType.dev:
        return ApiPath.devWsUrl;
    }
  }

  static String get apiUrl {
    String url = apiDomain;
    url += '/';
    return url;
  }

  static String get wsUrl {
    String url = wsDomain;
    url += '/';
    return url;
  }

  static void setServerType(ServerType type) {
    currentServer = type;
  }
}

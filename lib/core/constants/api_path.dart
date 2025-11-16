enum ServerType {
  dev,
  beta,
  prod,
}

class ApiPath {
  static const String devDomain = 'http://192.168.219.102:3000';
  static const String betaDomain = 'http://192.168.219.102:3000';
  static const String prodDomain = 'http://192.168.219.102:3000';

  static String devWsUrl = 'ws://192.168.219.102:3000';
  static String betaWsUrl = 'ws://192.168.219.102:3000';
  static String prodWsUrl = 'ws://192.168.219.102:3000';


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

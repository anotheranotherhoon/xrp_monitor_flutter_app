import '../services/base/api_constants.dart';

enum ServerType {
  dev,
  prod,
}

class ApiPath {
  static ServerType currentServer = ServerType.dev;

  static String get apiDomain {
    switch (currentServer) {
      case ServerType.prod:
        return ApiConstants.apiDomain;
      case ServerType.dev:
        return ApiConstants.apiDomain;
    }
  }
  static String get apiUrl {
    String url = apiDomain;
    url += '/';
    return url;
  }



  static void setServerType(ServerType type) {
    currentServer = type;
  }
}

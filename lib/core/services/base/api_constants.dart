import 'dart:io';

class ApiConstants {
  static const aos = "ANDROID";
  static const ios = "IOS";

  static const String devDomain = 'https://locall.host/3000';
  static const String betaDomain = 'https://locall.host/3000';
  static const String prodDomain = 'https://locall.host/3000';

  static String _devDomain = 'https://locall.host/3000';
  static String _betaDomain = 'https://locall.host/3000';
  static String _prodDomain = 'https://locall.host/3000';

  static const _devImageDomain = '';
  static const _betaImageDomain = '';
  static const _prodImageDomain = '';

  static const _aosGoogleApiKey = '';
  static const _iosGoogleApiKey = '';



  static var isDev = true;
  static var isBeta = false;

  static String get apiDomain {
    if (isDev) {
      return _devDomain;
    }
    if (isBeta) {
      return _betaDomain;
    }
    return _prodDomain;
  }

  static String get apiUrl {
    String url = apiDomain;
    url += '/api/';
    return url;
  }

  static String get imageDomain {
    if (isDev) {
      return _devImageDomain;
    }
    if (isBeta) {
      return _betaImageDomain;
    }
    return _prodImageDomain;
  }

  static String get geoApiKey {
    if(Platform.isIOS){
      return _iosGoogleApiKey;
    }else if(Platform.isAndroid){
      return _aosGoogleApiKey;
    }else {
      return '';
    }
  }


  static String checkVersionApi = '';

  static setCheckVersionApi() {
    if (isDev) {
      checkVersionApi = '$devDomain/api/';
    }else if (isBeta) {
      checkVersionApi = '$betaDomain/api/';
    } else {
      checkVersionApi = '$_prodDomain/api/';
    }
  }

  static setIsDomain(domain) {
    if (isDev) {
      _devDomain = domain;
    }else if (isDev) {
      _betaDomain = domain;
    } else {
      _prodDomain = domain;
    }
  }

  static setIsDev(api) {
    if (_devDomain == api) {
      isDev = true;
      isBeta = false;
    }else if (_betaDomain == api) {
      isDev = false;
      isBeta = true;
    } else if (_prodDomain == api) {
      isDev = false;
      isBeta = false;
    }
  }


}

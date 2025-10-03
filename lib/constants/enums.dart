enum StorageKey {
  //token(value: 'safe_school_token'),
  token(name: 'accessToken'),
  refreshToken(name: 'refreshToken'),
  notice(name: 'notice'),
  reward(name: 'reward');

  const StorageKey({
    required this.name,
  });

  final String name;
}

enum PassType {
  signUp,
  changePhoneNumber
}



enum PassRedirectResult {
  success,
  rejoinNotAllowed,
  duplicatePhone,
  invalidSession,
  invalidIntegrity,
  unknown,
}

PassRedirectResult parsePassResult(Uri uri) {
  final success = uri.queryParameters['success'];
  final reason = uri.queryParameters['reason'];

  if (success == 'true') return PassRedirectResult.success;

  switch (reason) {
    case 'rejoin_not_allowed':
      return PassRedirectResult.rejoinNotAllowed;
    case 'duplicate_phone':
      return PassRedirectResult.duplicatePhone;
    case 'invalid_session':
      return PassRedirectResult.invalidSession;
    case 'invalid_integrity':
      return PassRedirectResult.invalidIntegrity;
    default:
      return PassRedirectResult.unknown;
  }
}

// enum TermType {
//   service,
//   privacy,
//   age14,
//   location,
//   marketing,
//   marketingNight
// }

enum CertType {
  register('REGISTER'),
  resetPassword('RESET_PASSWORD'),
  changeEmail('CHANGE_EMAIL');
  const CertType(this.param);
  final String param;
}

enum CertStatus {
  none,
  success,
  codeExpired,
  incorrect,
}

enum RecommendCodeStatus {
  none,
  success,
  wrong,
}


enum OSType { ios, android }

enum YesNo {
  yes('YES'),
  no('NO');
  const YesNo(this.param);
  final String param;
}

YesNo yesNoFromString(String? value) {
  switch (value) {
    case 'YES':
      return YesNo.yes;
    case 'NO':
    default:
      return YesNo.no;
  }
}

enum DistanceUnit {
  fiveKm('5km', 5000),
  tenKm('10km', 10000),
  fiftyKm('50km', 50000),
  hundredKm('100km', 100000),
  fiveHundredKm('500km', 500000),
  infinity('∞', null);
  final String label;
  final int? param;
  const DistanceUnit(this.label, this.param);

  static List<DistanceUnit> get filterList => [
    fiveKm,
    tenKm,
    fiftyKm,
    hundredKm,
    fiveHundredKm,
    infinity,
  ];

}

enum LanguageType { KOREAN, AMERICA, INDIA, MALAYSIA }

enum UploadType { ADMIN, USER, PARTNER }


enum TermsType {
  SERVICE,
  PRIVACY_PROCESSING_POLICY,
  PRIVACY_COLLECTION_USE_POLICY,
  GEO,
  AD_INFO,
  NIGHT_AD_INFO,
  WITHDRAWN,
  AGE_14
}

enum FileType {
  MEMBER_PROFILE_IMAGE,
  CONTENT_IMAGE,
  POPUP_THUMBNAIL,
  INQUIRY_IMAGE,
  CREDIT_PRODUCT_IMAGE,
  EDITOR_IMAGE,
  VIDEO_TEST,
}

enum Gender { MALE, FEMALE, OTHER }

enum MemberType { KAKAO, APPLE, GOOGLE, NONE }


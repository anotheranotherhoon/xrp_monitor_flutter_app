enum StorageKey {
  //token(value: 'safe_school_token'),
  token(name: 'accessToken'),
  refreshToken(name: 'refreshToken'),
  portfolio(name: 'portfolio');
  const StorageKey({
    required this.name,
  });

  final String name;
}





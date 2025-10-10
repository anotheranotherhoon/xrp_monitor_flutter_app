enum StorageKey {
  // Secure Storage Keys (토큰 등 민감한 정보)
  token(name: 'accessToken'),
  refreshToken(name: 'refreshToken'),
  
  // Regular Storage Keys (일반 설정 등)
  portfolio(name: 'portfolio');
  
  const StorageKey({
    required this.name,
  });

  final String name;
}





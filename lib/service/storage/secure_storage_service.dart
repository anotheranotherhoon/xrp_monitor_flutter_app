import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:xrp_monitor/constants/enums.dart';

class SecureStorageService {
  SecureStorageService._internal();

  static final SecureStorageService _instance = SecureStorageService._internal();
  
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(),
  );

  static SecureStorageService get instance => _instance;

  // Token 관련 메서드들
  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageKey.token.name);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKey.refreshToken.name);
  }

  Future<void> setUserToken(String token) async {
    await _storage.write(key: StorageKey.token.name, value: token);
  }

  Future<void> setUserRefreshToken(String token) async {
    await _storage.write(key: StorageKey.refreshToken.name, value: token);
  }

  Future<void> setOperatorToken(String token) async {
    await _storage.write(key: StorageKey.token.name, value: token);
  }

  Future<void> removeAllToken() async {
    await _storage.delete(key: StorageKey.token.name);
    await _storage.delete(key: StorageKey.refreshToken.name);
  }

  Future<void> removeAccessToken() async {
    await _storage.delete(key: StorageKey.token.name);
  }

  Future<void> removeRefreshToken() async {
    await _storage.delete(key: StorageKey.refreshToken.name);
  }

  // 일반 저장소 메서드들
  Future<String?> getKeyName(String keyName) async {
    return await _storage.read(key: keyName);
  }

  Future<void> setKeyName(String keyName, String value) async {
    await _storage.write(key: keyName, value: value);
  }

  Future<void> removeKeyName(String keyName) async {
    await _storage.delete(key: keyName);
  }

  // 모든 데이터 삭제
  Future<void> removeAll() async {
    await _storage.deleteAll();
  }

  // 모든 키 가져오기
  Future<Map<String, String>> getAllKeys() async {
    return await _storage.readAll();
  }

  // 특정 키 존재 확인
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
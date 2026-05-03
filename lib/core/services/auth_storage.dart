import 'package:shared_preferences/shared_preferences.dart';

/// TokenStorage interface
abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String token);
  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String token);
  Future<void> clear();
}

class AuthStorage implements TokenStorage {
  final SharedPreferences prefs;

  AuthStorage(this.prefs);

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  @override
  Future<String?> getAccessToken() async {
    return prefs.getString(_accessTokenKey);
  }

  @override
  Future<void> setAccessToken(String token) async {
    await prefs.setString(_accessTokenKey, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<void> clear() async {
    await prefs.clear();
  }
}

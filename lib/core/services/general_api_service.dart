import 'package:dio/dio.dart';
import 'package:opket/core/env.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';
import 'package:opket/core/services/auth_storage.dart';
import 'package:opket/core/services/user_storage.dart';

class GeneralApiService {
  final api = sl<ApiClient>();

  Future<bool> verifyPassenger() async {
    try {
      final phone = await UserStorage().getPhone();
      if (phone == null) return false;

      final res = await api.get("/user/verify-passenger/$phone");

      final accessToken = res.data['accessToken'];
      final refreshToken = res.data['refreshToken'];

      sl<AuthStorage>().setAccessToken(accessToken);
      sl<AuthStorage>().setRefreshToken(refreshToken);

      return true;
    } catch (e) {
      return false;
      // rethrow;
    }
  }

  Future<void> sendAppInfo(String? version, bool? notificationEnabled) async {
    final phone = await UserStorage().getPhone();
    if (phone == null) return;

    try {
      await api.post("${Env.baseUrl}/user/app-version/$phone", {
        "notificationEnabled": notificationEnabled,
        "version": version,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final phone = await UserStorage().getPhone();
    if (phone == null) return;
    try {
      await api.post("${Env.baseUrl}/user/delete-account", {"phone": phone});
      await UserStorage().deletePhone();
    } catch (e) {
      rethrow;
    }
  }
}

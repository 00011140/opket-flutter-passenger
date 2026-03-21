import 'package:opket/services/general_api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyUserService {
  static const _verifiedKey = 'verified';

  /// Call this after you know the userId (e.g., after login),
  /// or call it with null userId and later re-call after login.
  static Future<void> verifyIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isVerified = prefs.getBool(_verifiedKey);

      if (isVerified != null && isVerified) return;

      final result = await GeneralApiService().verifyPassenger();

      // Only mark as reported if the call succeeded
      await prefs.setBool(_verifiedKey, result);
    } catch (e) {
      /// TODO:
    }
  }

  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    final current = '${info.version}+${info.buildNumber}';

    return current;
  }
}

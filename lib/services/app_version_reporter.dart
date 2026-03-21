import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:opket/services/general_api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppVersionReporter {
  static const _lastReportedKey = 'last_reported_app_version';
  static const _lastReportedNotificationKey = 'last_reported_notification';

  /// Call this after you know the userId (e.g., after login),
  /// or call it with null userId and later re-call after login.
  static Future<void> reportIfNeeded() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = '${info.version}+${info.buildNumber}';

      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getString(_lastReportedKey);

      if (last == current) return; // already sent for this app version
      // await sendToBackend(payload);
      await GeneralApiService().sendAppInfo(current, null);

      // Only mark as reported if the call succeeded
      await prefs.setString(_lastReportedKey, current);
    } catch (e) {
      /// TODO:
    }
  }

  static Future<void> reportIfNotificationInfo() async {
    try {
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();

      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getBool(_lastReportedNotificationKey);

      if (last == isAllowed) return; // already sent for this app version
      // await sendToBackend(payload);
      await GeneralApiService().sendAppInfo(null, isAllowed);

      // Only mark as reported if the call succeeded
      await prefs.setBool(_lastReportedNotificationKey, isAllowed);
    } catch (e) {
      /// TODO:
    }
  }

  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    final current = info.version;

    return current;
  }
}

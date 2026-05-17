import 'package:shared_preferences/shared_preferences.dart';

class ReportCacheService {
  static const _lastReportedKey = 'last_reported_app_version';
  static const _lastReportedNotificationKey = 'last_reported_notification';

  final SharedPreferences prefs;

  ReportCacheService({required this.prefs});

  Future<String?> getLastReportedVersion() async {
    final last = prefs.getString(_lastReportedKey);

    return last;
  }

  Future<void> saveLastReportedVersion(String current) async {
    await prefs.setString(_lastReportedKey, current);
  }

  bool? getLastReportedNotification() {
    return prefs.getBool(_lastReportedNotificationKey);
  }

  Future<void> saveLastReportedNotification(bool value) async {
    await prefs.setBool(_lastReportedNotificationKey, value);
  }
}

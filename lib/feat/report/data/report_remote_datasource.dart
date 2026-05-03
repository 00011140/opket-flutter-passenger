part of '../index.dart';

abstract class ReportRemoteDatasource {
  Future<void> report();
}

class ReportRemoteDatasourceImpl implements ReportRemoteDatasource {
  final ApiClient client;
  final ReportCacheService cacheService;

  ReportRemoteDatasourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<void> report() async {
    try {
      final appVersion = await _appVersion();
      final notificationEnabled = await AwesomeNotifications()
          .isNotificationAllowed();

      await client.post(
        "/user/report",
        Report(
          notificationEnabled: notificationEnabled,
          appVersion: appVersion,
        ).toMap(),
      );

      await cacheService.saveLastReportedVersion(appVersion);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _appVersion() async {
    final info = await PackageInfo.fromPlatform();
    final current = '${info.version}+${info.buildNumber}';

    return current;
  }
}

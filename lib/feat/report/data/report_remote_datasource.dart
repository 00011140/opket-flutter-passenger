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
    final info = await PackageInfo.fromPlatform();
    final appVersion = '${info.version}+${info.buildNumber}';
    final notificationEnabled = await AwesomeNotifications().isNotificationAllowed();

    final lastVersion = await cacheService.getLastReportedVersion();
    final lastNotification = cacheService.getLastReportedNotification();

    if (lastVersion == appVersion && lastNotification == notificationEnabled) return;

    await client.post(
      '/user/report',
      Report(notificationEnabled: notificationEnabled, appVersion: appVersion).toMap(),
    );

    await Future.wait([
      cacheService.saveLastReportedVersion(appVersion),
      cacheService.saveLastReportedNotification(notificationEnabled),
    ]);
  }
}

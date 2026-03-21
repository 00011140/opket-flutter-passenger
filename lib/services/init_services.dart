import 'package:firebase_core/firebase_core.dart';
import 'package:opket/firebase_options.dart';
import 'package:opket/services/app_version_reporter.dart';
import 'package:opket/services/connectivity_service.dart';
import 'package:opket/services/fcm_service.dart';
import 'package:opket/services/general_api_service.dart';
import 'package:opket/services/notification_service.dart';

class InitSerivces {
  Future<void> initServices() async {
    try {
      _initNotifications();
      FCMService.init();
      ConnectivityService().initialize();
      GeneralApiService().verifyPassenger();
      _sendAppInfo();
    } catch (e) {
      rethrow;
    }
  }

  void _sendAppInfo() {
    AppVersionReporter.reportIfNeeded();
    AppVersionReporter.reportIfNotificationInfo();
  }

  Future<void> _initNotifications() async {
    await NotificationService.initialize();
  }
}

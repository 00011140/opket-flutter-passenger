import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static const _iosBundleId = 'com.mtnoorapps.opket';

  static String? _iosStoreUrl;

  static Future<bool> isUpdateAvailable() async {
    try {
      if (Platform.isAndroid) {
        final info = await InAppUpdate.checkForUpdate();
        return info.updateAvailability == UpdateAvailability.updateAvailable;
      }
      if (Platform.isIOS) {
        return _checkIos();
      }
    } catch (e) {
      debugPrint('AppUpdateService: $e');
    }
    return false;
  }

  static Future<bool> _checkIos() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = _parse(info.version);

      final res = await http
          .get(Uri.parse(
              'https://itunes.apple.com/lookup?bundleId=$_iosBundleId'))
          .timeout(const Duration(seconds: 6));

      if (res.statusCode != 200) return false;

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final results = data['results'] as List?;
      if (results == null || results.isEmpty) return false;

      final entry = results[0] as Map<String, dynamic>;
      final storeVersion = entry['version'] as String?;
      if (storeVersion == null) return false;

      _iosStoreUrl = entry['trackViewUrl'] as String?;

      return _isNewer(_parse(storeVersion), current);
    } catch (_) {
      return false;
    }
  }

  static Future<void> openStore() async {
    try {
      if (Platform.isAndroid) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      } else if (Platform.isIOS && _iosStoreUrl != null) {
        final uri = Uri.parse(_iosStoreUrl!);
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('AppUpdateService.openStore: $e');
    }
  }

  static List<int> _parse(String v) =>
      v.split('.').map((p) => int.tryParse(p) ?? 0).toList();

  static bool _isNewer(List<int> store, List<int> current) {
    final len = store.length > current.length ? store.length : current.length;
    for (var i = 0; i < len; i++) {
      final s = i < store.length ? store[i] : 0;
      final c = i < current.length ? current[i] : 0;
      if (s > c) return true;
      if (s < c) return false;
    }
    return false;
  }
}

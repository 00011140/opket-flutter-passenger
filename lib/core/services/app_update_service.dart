import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:opket/core/admin_env.dart';
import 'package:opket/core/models/update_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static const _iosBundleId = 'com.mtnoorapps.opket';
  static String? _iosStoreUrl;

  static Future<UpdateInfo> checkUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = _parse(info.version);

      final config = await _fetchVersionConfig();
      if (config == null) return UpdateInfo.none;

      final minVersion = _parse(config['min_version'] as String);
      final latestVersion = _parse(config['latest_version'] as String);

      if (_isNewer(minVersion, current)) {
        return const UpdateInfo(isAvailable: true, isMandatory: true);
      }

      if (Platform.isAndroid) {
        final androidInfo = await InAppUpdate.checkForUpdate();
        if (androidInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          return const UpdateInfo(isAvailable: true, isMandatory: false);
        }
      } else if (Platform.isIOS) {
        final storeVersion = await _fetchIosStoreVersion();
        if (storeVersion != null && _isNewer(_parse(storeVersion), current)) {
          return const UpdateInfo(isAvailable: true, isMandatory: false);
        }
      }

      if (_isNewer(latestVersion, current)) {
        return const UpdateInfo(isAvailable: true, isMandatory: false);
      }
    } catch (e) {
      debugPrint('AppUpdateService.checkUpdate: $e');
    }
    return UpdateInfo.none;
  }

  static Future<Map<String, dynamic>?> _fetchVersionConfig() async {
    try {
      final url = '${AdminEnv.baseUrl}/public/app-version-config/passenger';
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return null;
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _fetchIosStoreVersion() async {
    try {
      final res = await http
          .get(Uri.parse('https://itunes.apple.com/lookup?bundleId=$_iosBundleId'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final results = data['results'] as List?;
      if (results == null || results.isEmpty) return null;
      final entry = results[0] as Map<String, dynamic>;
      _iosStoreUrl = entry['trackViewUrl'] as String?;
      return entry['version'] as String?;
    } catch (_) {
      return null;
    }
  }

  static Future<void> openStore({required bool isMandatory}) async {
    try {
      if (Platform.isAndroid) {
        if (isMandatory) {
          await InAppUpdate.performImmediateUpdate();
        } else {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      } else if (Platform.isIOS) {
        final url = _iosStoreUrl != null
            ? Uri.parse(_iosStoreUrl!)
            : Uri.parse('https://apps.apple.com/app/id$_iosBundleId');
        if (await canLaunchUrl(url)) await launchUrl(url);
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

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpamGuardRepository {
  static const _kCancelTimesKey = 'cancel_times';
  static const _kCooldownEndKey = 'cooldown_end';

  static const int maxCancels = 3;
  static const Duration window = Duration(minutes: 15);
  static const Duration cooldown = Duration(minutes: 20);

  Future<void> recordCancel() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final times = _loadTimes(prefs);
    final cutoff = now.subtract(window).millisecondsSinceEpoch;

    final filtered = times.where((t) => t >= cutoff).toList();
    filtered.add(now.millisecondsSinceEpoch);

    if (filtered.length >= maxCancels) {
      final cooldownEnd = now.add(cooldown).millisecondsSinceEpoch;
      await prefs.setInt(_kCooldownEndKey, cooldownEnd);

      // optional: clear list after triggering
      filtered.clear();
    }

    await prefs.setString(_kCancelTimesKey, jsonEncode(filtered));
  }

  Future<int?> getCooldownEndMs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kCooldownEndKey);
  }

  Future<void> clearCooldownIfExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final end = prefs.getInt(_kCooldownEndKey);
    if (end == null) return;
    if (DateTime.now().millisecondsSinceEpoch >= end) {
      await prefs.remove(_kCooldownEndKey);
    }
  }

  List<int> _loadTimes(SharedPreferences prefs) {
    final raw = prefs.getString(_kCancelTimesKey);
    if (raw == null) return <int>[];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <int>[];
    return decoded.whereType<num>().map((n) => n.toInt()).toList();
  }
}

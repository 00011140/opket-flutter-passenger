import 'package:shared_preferences/shared_preferences.dart';

class CooldownStorageService {
  static const String _prefsKey = "ride_request_cooldown";

  /// Save the cooldown end timestamp (in seconds since epoch)
  Future<void> saveCooldown(int secondsFromNow) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final endTime = now + secondsFromNow;
    await prefs.setInt(_prefsKey, endTime);
  }

  /// Get remaining cooldown in seconds
  /// Returns 0 if no cooldown or cooldown has expired
  Future<int> getRemainingCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    final int? endTime = prefs.getInt(_prefsKey);
    if (endTime == null) return 0;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = endTime - now;
    return remaining > 0 ? remaining : 0;
  }

  /// Clear the cooldown (optional)
  Future<void> clearCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}

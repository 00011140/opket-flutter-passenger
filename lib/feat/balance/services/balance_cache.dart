import 'package:shared_preferences/shared_preferences.dart';

class BalanceCache {
  static const _key = 'balance';

  static Future<void> save(num balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, balance.toString());
  }

  static Future<void> addToBalance(num amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBalance = await get();

    if (currentBalance != null) {
      final updatedBalance = currentBalance + amount;
      await prefs.setString(_key, updatedBalance.toString());
    }
  }

  static Future<num?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    return value != null ? num.tryParse(value) : null;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

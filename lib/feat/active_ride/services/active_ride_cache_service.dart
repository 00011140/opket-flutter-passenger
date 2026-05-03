import 'dart:convert';
import 'package:opket/feat/active_ride/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveRideCacheService {
  static const _rideStateKey = 'ride_state';

  /// Save CurrentRideState
  static Future<void> saveRideState(ActiveRideState state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.toMap());
    await prefs.setString(_rideStateKey, jsonString);
  }

  /// Load CurrentRideState
  static Future<ActiveRideState?> loadRideState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_rideStateKey);

    if (jsonString == null) return null;
    print(" 📤 📤 📤 📤 📤 📤 📤 📤 📤 📤 📤 📤");
    print(jsonString);
    final Map<String, dynamic> map = json.decode(jsonString);
    return ActiveRideState.fromMap(map);
  }

  /// Clear CurrentRideState
  static Future<void> clearRideState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rideStateKey);
  }
}

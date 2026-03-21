import 'dart:convert';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidePrefsService {
  static const _rideStateKey = 'ride_state';

  /// Save CurrentRideState
  static Future<void> saveRideState(CurrentRideState state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.toMap());
    await prefs.setString(_rideStateKey, jsonString);
  }

  /// Load CurrentRideState
  static Future<CurrentRideState?> loadRideState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_rideStateKey);

    if (jsonString == null) return null;

    final Map<String, dynamic> map = json.decode(jsonString);
    return CurrentRideState.fromMap(map);
  }

  /// Clear CurrentRideState
  static Future<void> clearRideState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rideStateKey);
  }
}

import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RidePersistService {
  static const _key = 'current_ride_state';
  static const _rideRequestKey = 'current_ride_request';

  Future<void> saveState(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<bool> hasOngoingRide() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    return raw != null;
  }

  Future<CurrentRideState?> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    final Map<String, dynamic> map = json.decode(raw);

    return CurrentRideState.fromMap(map);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // -------------------------
  // RIDE REQUEST
  // -------------------------

  Future<void> saveRideRequest(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rideRequestKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadRideRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_rideRequestKey);
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  Future<void> clearRideRequest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rideRequestKey);
  }
}

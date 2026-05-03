import 'dart:convert';

import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver_ride.dart';

class DriverRidesApi {
  final client = sl<ApiClient>();

  Future<List<DriverRide>> fetchDriverRides({
    required String period, // day|week|month|year
    required String date, // YYYY-MM-DD
    required String tz,
  }) async {
    try {
      final resp = await client.get(
        "/user/rides",
        query: {"period": period, "date": date, "tz": tz},
      );

      final list = (resp.data["rides"] as List).cast<Map<String, dynamic>>();
      return list.map(DriverRide.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Cache-first: returns cached if present, then refreshes and updates cache.
  /// Caller can decide whether to show "stale" indicator.
  Future<({List<DriverRide>? cached, List<DriverRide> fresh})>
  getRidesCacheFirst({
    required String period,
    required String date,
    required String tz,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = ridesCacheKey(period: period, date: date, tz: tz);

    List<DriverRide>? cached;
    final cachedStr = prefs.getString(key);
    if (cachedStr != null) {
      try {
        cached = decodeRides(cachedStr);
      } catch (_) {
        // ignore corrupt cache
      }
    }

    final fresh = await fetchDriverRides(period: period, date: date, tz: tz);

    await prefs.setString(key, encodeRides(fresh));
    await prefs.setInt("$key:ts", DateTime.now().millisecondsSinceEpoch);

    return (cached: cached, fresh: fresh);
  }

  Future<int?> getCacheTimestampMs({
    required String period,
    required String date,
    required String tz,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = ridesCacheKey(period: period, date: date, tz: tz);
    return prefs.getInt("$key:ts");
  }
}

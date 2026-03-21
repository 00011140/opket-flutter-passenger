import 'package:shared_preferences/shared_preferences.dart';
import 'fare_config_model.dart';

class FareCacheService {
  static const _keyFareConfig = "cached_fare_config";

  Future<void> saveFareConfig(FareConfigResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFareConfig, data.toRawJson());
  }

  Future<FareConfigResponseModel?> getFareConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFareConfig);
    if (raw == null) return null;
    return FareConfigResponseModel.fromRawJson(raw);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFareConfig);
  }
}

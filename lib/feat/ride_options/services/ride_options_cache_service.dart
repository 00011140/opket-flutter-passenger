part of '../index.dart';

class RideOptionsCacheService {
  static const _key = "ride_options";

  Future<void> saveData(List<RideOption> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert List<RideOption> -> List<Map> -> JSON string
    final dataString = jsonEncode(data.map((e) => e.toJson()).toList());

    await prefs.setString(_key, dataString);
  }

  Future<List<RideOption>?> getData() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null) return null;

    // Decode JSON string -> List<dynamic>
    final List decoded = jsonDecode(jsonString);

    // Convert to List<RideOption>
    return decoded
        .map((e) => RideOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

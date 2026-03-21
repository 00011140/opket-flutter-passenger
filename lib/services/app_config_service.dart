import 'package:opket/core/env.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/services/restaurants_cache.dart';
import 'package:opket/services/api_client.dart';
import 'package:opket/services/user_storage.dart';

class AppConfigService {
  final ApiClient client = ApiClient();

  Future<void> registerFcm(String fcmToken) async {
    try {
      final phone = await UserStorage().getPhone();

      if (phone == null) return;

      await client.post("${Env.baseUrl}/user/$phone/registerFcm", {
        "fcmToken": fcmToken,
      });
    } catch (e) {
      //
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final response = await client.get("http://localhost:4000/restaurants");
      final List rawData = response.data['restaurants'];

      final data = rawData.map((e) => RestaurantModel.fromJson(e)).toList();

      await RestaurantCache.save(data);

      return data;
    } catch (e) {
      rethrow;
    }
  }
}

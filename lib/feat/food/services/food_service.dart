import 'package:geolocator/geolocator.dart';
import 'package:opket/core/admin_env.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/models/cuisine_type_model.dart';
import 'package:opket/feat/food/models/delivery_fee_request_body.dart';
import 'package:opket/feat/food/models/delivery_fee_response.dart';
import 'package:opket/feat/food/models/food_category_model.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/services/cuisine_type_cache.dart';
import 'package:opket/feat/food/services/food_categories_cache.dart';
import 'package:opket/feat/food/services/restaurants_cache.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/core/services/api_client_new.dart';
import 'package:opket/core/services/auth_storage.dart';

class FoodService {
  final ApiClientNew client = ApiClientNew(
    baseUrl: AdminEnv.baseUrl,
    tokenStorage: sl<AuthStorage>(),
  );

  Future<List<FoodCategoryModel>> getCategories() async {
    try {
      final response = await client.get("/food/categories");
      final List categoriesRaw = response.data['categories'];

      final categories = categoriesRaw
          .map((e) => FoodCategoryModel.fromJson(e))
          .toList();

      final sorted = [...categories]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      await FoodCategoryCache.save(sorted);

      return sorted;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CuisineTypeModel>> getCuisinetypes() async {
    try {
      final response = await client.get("/admin/restaurant-types");
      final List categoriesRaw = response.data['categories'];

      final categories = categoriesRaw
          .map((e) => CuisineTypeModel.fromJson(e))
          .toList();

      final sorted = [...categories]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      await CuisineTypeCache.save(sorted);

      return sorted;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final response = await client.get("/restaurants");
      final List rawData = response.data['restaurants'];

      final data = rawData.map((e) => RestaurantModel.fromJson(e)).toList();

      await RestaurantCache.save(data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> calculateDeliveryFee(DeliveryFeeRequestBody data) async {
    try {
      final response = await client.post(
        "/food/delivery-fee",
        data: data.toJson(),
      );

      final result = DeliveryFeeResponse.fromJson(response.data);

      return result.fee.toInt();
    } catch (e) {
      rethrow;
    }
  }

  Future<FoodOrder> orderfood(CartState data) async {
    try {
      final position = await Geolocator.getCurrentPosition();

      final response = await client.post(
        "/food/order-food",
        data: {
          ...data.toCreateOrderJson(),
          "dropoff": {'lat': position.latitude, 'lon': position.longitude},
        },
      );

      final FoodOrder order = FoodOrder.fromJson(response.data['data']);

      return order;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderStatus> getOrderStatus(String id) async {
    try {
      final response = await client.get("/food/orders/$id/status");

      final status = response.data['data'];

      return orderStatusFromString(status);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FoodOrder>> getActiveOrders() async {
    try {
      final response = await client.get("/food/orders/active");

      List orders = response.data['orders'];

      return orders.map((e) => FoodOrder.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

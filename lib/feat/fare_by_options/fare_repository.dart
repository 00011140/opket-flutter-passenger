import 'fare_api_service.dart';
import 'fare_cache_service.dart';
import 'fare_config_model.dart';

class FareRepository {
  final FareApiService api;
  final FareCacheService cache;

  FareRepository({required this.api, required this.cache});

  Future<FareConfigResponseModel?> getCached() {
    return cache.getFareConfig();
  }

  Future<FareConfigResponseModel> fetchAndCache() async {
    final data = await api.fetchFareConfigUser();
    await cache.saveFareConfig(data);
    return data;
  }
}

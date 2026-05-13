part of '../index.dart';

abstract class RideOptionsRemoteDatasource {
  Future<List<RideOption>> getRideOptions();
}

class RideOptionsRemoteDatasourceImpl implements RideOptionsRemoteDatasource {
  final cacheService = RideOptionsCacheService();

  final client = ApiClientNew(
    baseUrl: AdminEnv.baseUrl,
    tokenStorage: sl<AuthStorage>(),
  );

  @override
  Future<List<RideOption>> getRideOptions() async {
    try {
      final response = await client.get("/ride-options/");
      final List rawList = response.data;
      final data = rawList
          .map((e) => RideOption.fromJson(e))
          .where((o) => o.showInPassengerApp)
          .toList();

      await cacheService.saveData(data);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}

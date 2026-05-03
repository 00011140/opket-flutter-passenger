part of '../index.dart';

abstract class RideOptionsLocalDatasource {
  Future<List<RideOption>> getRideOptions();
  Future<void> saveRideOptions(List<RideOption> options);
}

class RideOptionsLocalDatasourceImpl implements RideOptionsLocalDatasource {
  final service = RideOptionsCacheService();

  @override
  Future<List<RideOption>> getRideOptions() async {
    try {
      final options = await service.getData();

      return options ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveRideOptions(List<RideOption> options) async {
    try {
      await service.saveData(options);
    } catch (e) {
      rethrow;
    }
  }
}

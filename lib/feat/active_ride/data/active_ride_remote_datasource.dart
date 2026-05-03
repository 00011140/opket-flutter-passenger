part of '../index.dart';

abstract class ActiveRideRemoteDatasource {
  Future<RideModel> getCurrentRide(GetCurrentRideParams params);
}

class ActiveRideRemoteDatasourceImpl implements ActiveRideRemoteDatasource {
  final api = sl<ApiClient>();

  @override
  Future<RideModel> getCurrentRide(params) async {
    try {
      final res = await api.get('/user/${params.rideId}/current-ride');

      return RideModel.fromMap(res.data);
    } catch (e) {
      rethrow;
    }
  }
}

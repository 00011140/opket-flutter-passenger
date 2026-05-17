part of '../index.dart';

abstract class ActiveRideRemoteDatasource {
  Future<RideModel> getCurrentRide(GetCurrentRideParams params);
  Future<void> setUseBalance({required String rideId, required bool useBalance});
  Future<void> rateRide({required String rideId, required int rating, String? comment});
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

  @override
  Future<void> setUseBalance({required String rideId, required bool useBalance}) async {
    await api.patch('/user/ride/$rideId/use-balance', {'useBalance': useBalance});
  }

  @override
  Future<void> rateRide({required String rideId, required int rating, String? comment}) async {
    await api.post('/user/ride/$rideId/rate', {
      'rating': rating,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
  }
}

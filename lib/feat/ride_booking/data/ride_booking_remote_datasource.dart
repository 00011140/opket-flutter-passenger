import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';
import 'package:opket/core/services/user_storage.dart';
import 'package:opket/feat/ride_booking/domain/usecases/cancel_ride.dart';
import 'package:opket/feat/ride_booking/domain/usecases/request_ride.dart';

enum RideType { standard, comfort, premium }

typedef RideRequestResult = ({String rideId, int searchDurationMs});

abstract class RideBookingRemoteDatasource {
  Future<RideRequestResult> requestRide(RequestRideParams params);
  Future<void> cancelRide(CancelRideParams params);
}

class RideBookingRemoteDatasourceImpl implements RideBookingRemoteDatasource {
  final api = sl<ApiClient>();

  @override
  Future<RideRequestResult> requestRide(params) async {
    final location = params.location;
    final options = params.options;
    final phone = await UserStorage().getPhone();

    try {
      final response = await api.post('/user/request-ride', {
        'pickup': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
        'phone': phone,
        "options": options,
        "rideType": _rideType(options),
      });

      final rideId = response.data['ride_id'] as String;
      final searchDurationMs =
          (response.data['searchDurationMs'] as num?)?.toInt() ?? 3 * 60 * 1000;
      return (rideId: rideId, searchDurationMs: searchDurationMs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelRide(params) async {
    try {
      final body = <String, dynamic>{'rideId': params.rideId};
      if (params.reasonKey != null && params.reasonKey!.isNotEmpty) {
        body['reasonKey'] = params.reasonKey;
      }
      await api.post('/user/cancel-ride', body);
    } catch (e) {
      rethrow;
    }
  }

  static String _rideType(List<String> options) {
    if (options.contains(RideType.premium.name)) {
      return RideType.premium.name;
    } else if (options.contains(RideType.comfort.name)) {
      return RideType.comfort.name;
    } else {
      return RideType.standard.name;
    }
  }
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/di/sl.dart';
import 'package:opket/services/api_client.dart';
import 'package:opket/services/auth_storage.dart';
import 'package:opket/services/fcm_service.dart';
import 'package:opket/services/referral_service.dart';
import 'package:opket/services/socket_service.dart';
import 'package:opket/services/user_storage.dart';

import 'audio_service.dart';

enum RideType { standard, comfort, premium }

class RequestRideService {
  final api = ApiClient();

  static String _rideType(List<String> options) {
    if (options.contains(RideType.premium.name)) {
      return RideType.premium.name;
    } else if (options.contains(RideType.comfort.name)) {
      return RideType.comfort.name;
    } else {
      return RideType.standard.name;
    }
  }

  Future<String?> requestRide(
    LatLng? location,
    bool isPremium,
    List<String> options,
  ) async {
    final phone = await UserStorage().getPhone();

    if (location == null) return null;

    try {
      final response = await api.post('/user/request-ride', {
        'location': {'lat': location.latitude, 'lon': location.longitude},
        'phone': phone,
        "options": options,
        "rideType": _rideType(options),
      });

      return response.data['ride_id'];
    } catch (e) {
      await AudioService().stopSound();
      rethrow;
    }
  }

  Future<void> cancelRide(String? rideId) async {
    try {
      await api.post('/user/cancel-ride', {'rideId': rideId});
    } catch (e) {
      await AudioService().stopSound();
      rethrow;
    }
  }

  Future<void> createUser(int phone) async {
    final referralCode = await ReferralService.getPendingReferral();
    final existingPhone = await UserStorage().getPhone();

    try {
      final res = await api.post('/user/create', {
        'phone': phone,
        'existingPhone': existingPhone,
        'referralCode': referralCode ?? "69704d490cb9e2862e64f082",
      });
      await UserStorage().savePhone(phone);
      await FCMService.init();
      SocketService.instance.connect(phone);

      final accessToken = res.data['accessToken'];
      final refreshToken = res.data['refreshToken'];

      await sl<AuthStorage>().setAccessToken(accessToken);
      await sl<AuthStorage>().setRefreshToken(refreshToken);
    } catch (e) {
      rethrow;
    }
  }
}

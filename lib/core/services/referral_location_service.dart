import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';

class ReferralLocationService {
  static bool _verified = false;

  static Future<void> verifyLocation(double lat, double lng) async {
    if (_verified) return;
    _verified = true;
    try {
      await sl<ApiClient>().post('/user/referral/submit-location', {'lat': lat, 'lng': lng});
    } catch (_) {
      _verified = false; // allow retry on failure
    }
  }
}

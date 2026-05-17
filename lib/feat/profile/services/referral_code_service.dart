import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';

class ReferralCodeService {
  final _api = sl<ApiClient>();

  Future<String?> getMyReferralCode() async {
    final response = await _api.get('/user/my-referral-code');
    return response.data['referralCode'] as String?;
  }
}

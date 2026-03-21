import 'package:dio/dio.dart';
import 'package:opket/feat/balance/models/pay_fare_model.dart';
import 'package:opket/models/error_response.dart';
import 'package:opket/services/api_client.dart';
import 'package:opket/services/user_storage.dart';
import 'balance_cache.dart';

class BalanceService {
  final api = ApiClient();

  Future<int> getBalance() async {
    final phone = await UserStorage().getPhone();

    try {
      final response = await api.get('/user/$phone/balance');
      final balance = response.data['balance'] ?? 0;
      await BalanceCache.save(balance);

      return balance;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> payFare(PayFareModel payFareData) async {
    final phone = await UserStorage().getPhone();

    try {
      final response = await api.post(
        '/user/$phone/pay-fare',
        payFareData.toMap(),
      );
      final balance = response.data['balance'] ?? 0;
      await BalanceCache.save(balance);

      return balance;
    } on DioException catch (e) {
      final response = ErrorResponse.fromMap(e.response?.data);
      throw response;
    }
  }
}

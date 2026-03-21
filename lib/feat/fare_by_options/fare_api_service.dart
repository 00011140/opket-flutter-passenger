import 'package:dio/dio.dart';
import 'package:opket/core/env.dart';
import 'fare_config_model.dart';

class FareApiService {
  final Dio dio = Dio();

  Future<FareConfigResponseModel> fetchFareConfigUser() async {
    final res = await dio.get("${Env.baseUrl}/user/fare/config");

    // backend: { success: true, fare, farePremium }
    return FareConfigResponseModel.fromJson(res.data);
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:opket/services/sms_api_client.dart';
import 'package:opket/utils/extensions.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'otp_service.dart';

class SmsApiService {
  final smsApi = SmsApiClient().dio;
  final otpService = OtpService();

  Future<void> sendOtpCode(int phone) async {
    try {
      final otp = otpService.generateOtp();
      String message;

      if (Platform.isAndroid) {
        final hash = await SmsAutoFill().getAppSignature;

        message =
            "<#> Kod $otp - OPKET mobil ilovasiga kirish uchun tasdiqlash kodingiz.\n$hash";
      } else {
        message =
            "<#>OPKET mobil ilovasiga kirish uchun tasdiqlash kodi - $otp";
      }

      await otpService.saveOtp(phone: phone, otp: otp);

      final response = await smsApi.post(
        'message/sms/send',
        data: FormData.fromMap({
          'mobile_phone': phone.addUzbCode(),
          'message': message,
          'from': "4546",
          'callback_url': "",
        }),
      );

      print("response");
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> verifyOtpCode({
    required int phone,
    required int enteredOtp,
  }) async {
    final isValid = await otpService.validateOtp(
      phone: phone,
      enteredOtp: enteredOtp,
    );

    return isValid;
  }
}

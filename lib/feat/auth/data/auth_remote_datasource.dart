import 'dart:io';

import 'package:dio/dio.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';
import 'package:opket/core/services/auth_storage.dart';
import 'package:opket/core/services/otp_service.dart';
import 'package:opket/core/services/referral_service.dart';
import 'package:opket/core/services/sms_api_client.dart';
import 'package:opket/core/services/socket_service.dart';
import 'package:opket/core/services/user_storage.dart';
import 'package:opket/feat/auth/domain/usecases/register_user.dart';
import 'package:opket/feat/auth/domain/usecases/verify_otp.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:sms_autofill/sms_autofill.dart';

abstract class AuthRemoteDatasource {
  Future<void> sendOtp(int phone);
  Future<bool> verifyOtp(VerifyOtpParams params);
  Future<void> registerUser(RegisterUserParams params);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final smsClient = SmsApiClient().dio;
  final api = sl<ApiClient>();

  final OtpService otpService;

  AuthRemoteDatasourceImpl({required this.otpService});

  @override
  Future<void> sendOtp(int phone) async {
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

      final response = await smsClient.post(
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
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<bool> verifyOtp(params) async {
    final isValid = await otpService.validateOtp(
      phone: params.phone,
      enteredOtp: params.otp,
    );

    return isValid;
  }

  @override
  Future<void> registerUser(params) async {
    final phone = params.phone;
    // Manual code (entered by user) takes priority over QR-based install referrer
    final referralCode = (params.manualReferralCode != null && params.manualReferralCode!.isNotEmpty)
        ? params.manualReferralCode
        : await ReferralService.getPendingReferral();
    final existingPhone = await UserStorage().getPhone();

    try {
      final res = await api.post('/user/create', {
        'phone': phone,
        'existingPhone': existingPhone,
        if (referralCode != null && referralCode.isNotEmpty) 'referralCode': referralCode,
      });
      await UserStorage().savePhone(phone);

      final accessToken = res.data['accessToken'];
      final refreshToken = res.data['refreshToken'];

      await sl<AuthStorage>().setAccessToken(accessToken);
      await sl<AuthStorage>().setRefreshToken(refreshToken);

      SocketService.instance.connect(accessToken);
    } catch (e) {
      rethrow;
    }
  }
}

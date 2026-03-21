import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class OtpService {
  static const String _otpKey = 'otp_code';
  static const String _otpExpiryKey = 'otp_expiry';
  static const String _otpUserKey = 'otp_user';

  // Generate a 6-digit random OTP
  int generateOtp() {
    final rand = Random.secure();
    final otp = (rand.nextInt(9000) + 1000);
    return otp;
  }

  // Save OTP with expiration + userId
  Future<void> saveOtp({
    required int phone,
    required int otp,
    Duration expiry = const Duration(minutes: 2),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimestamp = DateTime.now().add(expiry).millisecondsSinceEpoch;

    await prefs.setInt(_otpKey, otp);
    await prefs.setInt(_otpExpiryKey, expiryTimestamp);
    await prefs.setInt(_otpUserKey, phone);
  }

  // Validate OTP for a specific user
  Future<bool> validateOtp({
    required int phone,
    required int enteredOtp,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedOtp = prefs.getInt(_otpKey);
    final savedUser = prefs.getInt(_otpUserKey);
    final expiry = prefs.getInt(_otpExpiryKey);

    if (savedOtp == null || savedUser == null || expiry == null) {
      return false; // No OTP saved
    }

    // Check user matches
    if (savedUser != phone) {
      return false; // OTP belongs to someone else
    }

    // Check expiration
    if (DateTime.now().millisecondsSinceEpoch > expiry) {
      await clearOtp();
      return false; // OTP expired
    }
    // Validate OTP value
    final isValid = savedOtp == enteredOtp;

    // Clear OTP once used
    if (isValid) {
      await clearOtp();
    }

    return isValid;
  }

  // Clear stored OTP
  Future<void> clearOtp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_otpKey);
    await prefs.remove(_otpExpiryKey);
    await prefs.remove(_otpUserKey);
  }
}

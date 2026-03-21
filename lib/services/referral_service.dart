import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

import 'dart:async';

class ReferralService {
  static const _referralKey = 'install_referral_code';
  static const _consumedKey = 'install_referral_consumed';

  static Future<InitResult>? _initFuture;

  /// Safe to call multiple times.
  static Future<InitResult> init() {
    _initFuture ??= _initInternal();
    return _initFuture!;
  }

  static Future<InitResult> _initInternal() async {
    if (!Platform.isAndroid) return const InitResult.skipped('Not Android');

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_referralKey);
    if (existing != null && existing.isNotEmpty) {
      return const InitResult.alreadyInitialized();
    }

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final details = await PlayInstallReferrer.installReferrer;
        final referrer = details.installReferrer;

        if (referrer != null && referrer.isNotEmpty) {
          final params = Uri.splitQueryString(referrer);
          final code = params['ref'];

          if (code != null && code.isNotEmpty) {
            await prefs.setString(_referralKey, code);
            await prefs.setBool(_consumedKey, false);
            return InitResult.saved(code);
          }
          return const InitResult.noReferralCode();
        }
      } catch (_) {
        // fall through to retry
      }

      await Future.delayed(Duration(milliseconds: 300 * (attempt + 1)));
    }

    return const InitResult.noReferrer();
  }

  /// Returns a referral code only if it exists and hasn't been consumed.
  static Future<String?> getPendingReferral() async {
    await init();

    final prefs = await SharedPreferences.getInstance();
    final bool consumed = prefs.getBool(_consumedKey) ?? false;
    if (consumed) return null;

    final code = prefs.getString(_referralKey);
    return (code == null || code.isEmpty) ? null : code;
  }

  static Future<void> markConsumed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consumedKey, true);
  }

  /// Optional helper if you need to show/debug what happened, similar to the example's String.
  static Future<String> initDebugString() async {
    final r = await init();
    return r.toString();
  }

  /// Optional: for testing or re-install scenarios.
  static Future<void> resetForDebug() async {
    _initFuture = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_referralKey);
    await prefs.remove(_consumedKey);
  }
}

/// Small typed result instead of swallowing errors.
/// This is the service equivalent of the example's `_referrerDetails` string.
sealed class InitResult {
  const InitResult();

  const factory InitResult.saved(String code) = _Saved;
  const factory InitResult.alreadyInitialized() = _AlreadyInitialized;
  const factory InitResult.noReferrer() = _NoReferrer;
  const factory InitResult.noReferralCode() = _NoReferralCode;
  const factory InitResult.failed(Object error) = _Failed;
  const factory InitResult.skipped(String reason) = _Skipped;

  @override
  String toString() {
    return switch (this) {
      _Saved(:final code) => 'Saved referral code: $code',
      _AlreadyInitialized() => 'Already initialized (code present)',
      _NoReferrer() => 'No install referrer string returned',
      _NoReferralCode() => 'No "ref" param found in referrer string',
      _Failed(:final error) => 'Failed to get referrer details: $error',
      _Skipped(:final reason) => 'Skipped: $reason',
    };
  }
}

class _Saved extends InitResult {
  final String code;
  const _Saved(this.code);
}

class _AlreadyInitialized extends InitResult {
  const _AlreadyInitialized();
}

class _NoReferrer extends InitResult {
  const _NoReferrer();
}

class _NoReferralCode extends InitResult {
  const _NoReferralCode();
}

class _Failed extends InitResult {
  final Object error;
  const _Failed(this.error);
}

class _Skipped extends InitResult {
  final String reason;
  const _Skipped(this.reason);
}

import 'package:dartz/dartz.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/auth/domain/usecases/register_user.dart';
import 'package:opket/feat/auth/domain/usecases/verify_otp.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> sendOtp(int phone);
  Future<Either<Failure, bool>> verifyOtp(VerifyOtpParams params);
  Future<Either<Failure, void>> registerUser(RegisterUserParams params);
}

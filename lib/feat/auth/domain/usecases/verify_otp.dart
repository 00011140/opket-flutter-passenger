import 'package:dartz/dartz.dart';
import 'package:opket/core/config/usecase.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/auth/domain/repo/auth_repo.dart';

class VerifyOtp extends UseCase<bool, VerifyOtpParams> {
  final AuthRepo repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.verifyOtp(params);
  }
}

class VerifyOtpParams {
  final int phone;
  final int otp;

  VerifyOtpParams({required this.phone, required this.otp});
}

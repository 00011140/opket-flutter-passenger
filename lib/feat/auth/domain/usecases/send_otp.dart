import 'package:dartz/dartz.dart';
import 'package:opket/core/config/usecase.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/auth/domain/repo/auth_repo.dart';

class SendOtp extends UseCase<void, int> {
  final AuthRepo repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(phone) async {
    return await repository.sendOtp(phone);
  }
}

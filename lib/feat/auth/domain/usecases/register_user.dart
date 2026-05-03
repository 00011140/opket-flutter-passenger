import 'package:dartz/dartz.dart';
import 'package:opket/core/config/usecase.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/auth/domain/repo/auth_repo.dart';

class RegisterUser extends UseCase<void, RegisterUserParams> {
  final AuthRepo repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.registerUser(params);
  }
}

class RegisterUserParams {
  final int phone;

  RegisterUserParams({required this.phone});
}

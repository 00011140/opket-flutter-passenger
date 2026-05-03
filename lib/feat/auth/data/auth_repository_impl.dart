import 'package:dartz/dartz.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/auth/domain/repo/auth_repo.dart';
import 'package:opket/feat/auth/domain/usecases/register_user.dart';

import 'auth_remote_datasource.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDatasource remoteDataSource;

  AuthRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> sendOtp(int phone) async {
    try {
      await remoteDataSource.sendOtp(phone);
      return Right(null);
    } catch (e) {
      return Left(
        GeneralFailure(
          "Bu raqam kod jo'natib bo'lmadi iltimos qaytadan urinib ko'ring",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(RegisterUserParams params) async {
    try {
      final result = await remoteDataSource.registerUser(params);
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure("Xatolik yuz berdi"));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(params) async {
    try {
      final result = await remoteDataSource.verifyOtp(params);
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure("Kiritilgan kod xato"));
    }
  }
}

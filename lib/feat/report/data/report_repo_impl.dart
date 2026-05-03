part of '../index.dart';

class ReportRepoImpl implements ReportRepo {
  final ReportRemoteDatasource remoteDataSource;

  ReportRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> report() async {
    try {
      await remoteDataSource.report();
      return Right(null);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}

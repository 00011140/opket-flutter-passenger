part of '../../index.dart';

class ReportAppInfo extends UseCase<void, void> {
  final ReportRepo repository;

  ReportAppInfo(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.report();
  }
}

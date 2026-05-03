part of '../../index.dart';

abstract class ReportRepo {
  Future<Either<Failure, void>> report();
}

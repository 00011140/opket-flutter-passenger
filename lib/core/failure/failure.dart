import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'Unknown error']);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class GeneralFailure extends Failure {
  const GeneralFailure([super.message = 'Failed to back up data']);
}

class RestoreFailure extends Failure {
  const RestoreFailure([String message = 'Failed to restore data'])
    : super(message);
}

class IsUserInChallenge extends Failure {
  const IsUserInChallenge([String message = 'User is not the challenge'])
    : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'ServerFailure']) : super(message);
}

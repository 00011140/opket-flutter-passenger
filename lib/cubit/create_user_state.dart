part of 'create_user_cubit.dart';

abstract class CreateUserState {}

class CreateUserInitial extends CreateUserState {}

class CreateUserLoading extends CreateUserState {}

class CreateUserError extends CreateUserState {
  final String message;
  CreateUserError({required this.message});
}

class CreateUserSuccess extends CreateUserState {
  final int phone;

  CreateUserSuccess({required this.phone});
}

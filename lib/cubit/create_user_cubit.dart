import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/cubit/auth_cubit.dart';
import 'package:opket/services/request_ride_service.dart';

part 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  final AuthCubit authCubit;

  CreateUserCubit(this.authCubit) : super(CreateUserInitial());

  Future<void> createUser(int phone) async {
    emit(CreateUserLoading());
    try {
      await RequestRideService().createUser(phone);

      emit(CreateUserSuccess(phone: phone));
      authCubit.authenticated();
    } catch (e) {
      emit(CreateUserError(message: e.toString()));
    }
  }

  void reset() {
    emit(CreateUserInitial());
  }
}

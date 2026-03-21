import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/services/user_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void init() async {
    final phone = await UserStorage().getPhone();

    if (phone != null) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }

  void authenticated() {
    emit(Authenticated());
  }
}

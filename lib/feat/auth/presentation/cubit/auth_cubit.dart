import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/auth_storage.dart';
import 'package:opket/core/services/socket_service.dart';
import 'package:opket/core/services/user_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void init() async {
    // final phone = await UserStorage().getPhone();
    final token = await sl<AuthStorage>().getAccessToken();

    if (token != null) {
      emit(Authenticated());
      SocketService.instance.connect(token);
    } else {
      emit(UnAuthenticated());
    }
  }

  void authenticated() async {
    final token = await sl<AuthStorage>().getAccessToken();
    if (token != null) {
      SocketService.instance.connect(token);
    }
    emit(Authenticated());
  }

  Future<void> logout() async {
    SocketService.instance.disconnect();
    await sl<AuthStorage>().clear();
    await UserStorage().deletePhone();
    emit(UnAuthenticated());
  }
}

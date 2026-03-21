import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/services/init_services.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());

  void init() async {
    try {
      await InitSerivces().initServices();
      emit(ServicesInitSuccess());
    } catch (e) {
      emit(ServicesInitError(message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/report/index.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ReportAppInfo reportUsecase;

  ServicesCubit(this.reportUsecase) : super(ServicesInitial());

  void init() async {
    try {
      await reportUsecase(null);
      emit(ServicesInitSuccess());
    } catch (e) {
      emit(ServicesInitError(message: e.toString()));
    }
  }
}

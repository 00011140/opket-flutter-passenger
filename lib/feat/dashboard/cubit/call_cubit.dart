import 'package:flutter_bloc/flutter_bloc.dart';

class CallCubit extends Cubit<bool> {
  CallCubit() : super(false);

  void setCallingPageStatus(bool value) {
    emit(value);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<bool> {
  LocationCubit() : super(false);

  void setData(bool value) {
    emit(value);
  }
}

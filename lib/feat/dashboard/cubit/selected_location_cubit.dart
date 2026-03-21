import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedLocationCubit extends Cubit<LatLng?> {
  SelectedLocationCubit() : super(null);

  void setData(LatLng value) {
    print(value);
    emit(value);
  }
}

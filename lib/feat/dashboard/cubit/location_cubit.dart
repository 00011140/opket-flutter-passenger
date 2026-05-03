import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/services/location_service.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  void checkLocationPermission() async {
    final permissionResult = await LocationService.requestPermission();
    print(permissionResult.granted);

    if (permissionResult.granted) {
      emit(LocationPermissionGranted());
    } else {
      emit(LocationPermissionDenied());
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/services/location_service.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial()) {
    // Check on creation so that users who already granted permission get
    // LocationPermissionGranted without needing to interact with a dialog.
    // app_providers.dart also calls RideMapCubit()..init() directly, but
    // this ensures the LocationPermissionGranted state is always correct
    // for any listener watching it (e.g. RideEffectListener).
    _checkOnStartup();
  }

  Future<void> _checkOnStartup() async {
    final granted = await LocationService.isPermissionGranted();
    if (granted) {
      emit(LocationPermissionGranted());
    }
    // Do not emit Denied on startup — permission hasn't been requested yet.
    // Denied is only emitted after an explicit user-facing request.
  }

  Future<void> checkLocationPermission() async {
    final permissionResult = await LocationService.requestPermission();

    if (permissionResult.granted) {
      emit(LocationPermissionGranted());
    } else {
      emit(LocationPermissionDenied());
    }
  }
}

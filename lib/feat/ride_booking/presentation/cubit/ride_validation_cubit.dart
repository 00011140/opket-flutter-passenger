import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opket/core/services/connectivity_service.dart';
import 'package:opket/core/services/location_service.dart';
import 'package:opket/core/services/user_storage.dart';

part 'ride_validation_state.dart';

class RideValidationCubit extends Cubit<RideValidationState> {
  final ConnectivityService connectivityService;

  RideValidationCubit({required this.connectivityService})
    : super(RideValidationInitial());

  Future<void> validateRequest(bool isUserLocation) async {
    // INTERNET
    if (!connectivityService.hasInternet) {
      emit(NoInternet());
      return;
    }

    // USER PHONE NUMBER
    final phone = await UserStorage().getPhone();
    if (phone == null) {
      emit(NotAuthenticated());
      return;
    }

    // LOCATION SERVICES
    final isLocationServicesEnabled = await LocationService.isLocationEnabled();
    if (!isLocationServicesEnabled) {
      emit(LocationServicesNotEnabled());
      return;
    }

    // LOCATION
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    final denied = permission == LocationPermission.denied;
    final deniedForever = permission == LocationPermission.deniedForever;

    if (deniedForever) {
      emit(LocationPermissionDeniedForever());
      return;
    } else if (denied) {
      emit(LocationPermissionDenied());
    }

    // NOT CURRENT USER LOCATION
    if (!isUserLocation) {
      emit(NotCurrentUserLocation());
      return;
    }

    emit(RideValidationSuccess());
  }

  void reset() {
    emit(RideValidationInitial());
  }
}

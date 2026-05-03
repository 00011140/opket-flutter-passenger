part of '../../index.dart';

class ActiveRideCubit extends Cubit<ActiveRideState> {
  final RideStreamRepository repository;
  final GetCurrentRide getCurrentRideUsecase;
  StreamSubscription? _sub;

  ActiveRideCubit({
    required this.repository,
    required this.getCurrentRideUsecase,
  }) : super(ActiveRideState(progress: RideProgress())) {
    _sub = repository.events.listen(_onEvent);
  }

  void init() async {
    final cachedState = await ActiveRideCacheService.loadRideState();
    if (cachedState == null) return;

    // ✅ Always restore immediately
    emit(cachedState);

    final rideId = cachedState.rideId;

    // ✅ Then reconcile with backend
    if (cachedState.status == RideStatus.searching && rideId != null) {
      await fetchCurrentRide(rideId);
    }
  }

  Future<void> fetchCurrentRide(String rideId) async {
    try {
      final result = await getCurrentRideUsecase(
        GetCurrentRideParams(rideId: rideId),
      );

      result.fold((l) => {}, (ride) {
        emit(
          state.copyWith(
            driver: ride.driver,
            location: ride.driverLocation,
            status: RideStatus.accepted,
          ),
        );
        _saveStateToCache();
      });
    } catch (e) {
      // handle error
    }
  }

  void handleRideAccepted({
    required DriverModel driver,
    required DriverLocation location,
  }) {
    _onEvent(RideAccepted(driver: driver, location: location));
  }

  void setPickupLocation(LatLng pickupLocation) {
    emit(state.copyWith(pickupLocation: pickupLocation));
    _saveStateToCache();
  }

  void onRideCreated(String rideId) {
    emit(state.copyWith(rideId: rideId, status: RideStatus.searching));
    _saveStateToCache();
  }

  void _onEvent(RideEvent event) {
    switch (event) {
      case RideCreated():
        emit(
          state.copyWith(rideId: event.rideId, status: RideStatus.searching),
        );

      case RideAccepted():
        emit(
          state.copyWith(
            driver: event.driver,
            location: event.location,
            status: RideStatus.accepted,
          ),
        );

      case RouteUpdated():
        emit(state.copyWith(routeUpdate: event.data));
      case DriverLocationUpdated():
        emit(state.copyWith(candidateDrivers: event.data));

      case DriverArrived():
        emit(state.copyWith(status: RideStatus.arrived));

      case RideStarted():
        emit(
          state.copyWith(
            status: RideStatus.started,
            progress: RideProgress(fare: 0, distance: 0),
          ),
        );
      case RideCompleted():
        emit(state.copyWith(status: RideStatus.completed));
        reset();
        ActiveRideCacheService.clearRideState();
      case NoDriversFound():
        emit(state.copyWith(status: RideStatus.cancelled));

      case OnRideProgress():
        emit(state.copyWith(progress: event.data));

      case OnDriverLocation():
        emit(state.copyWith(location: event.data));
    }

    _saveStateToCache();
  }

  void _saveStateToCache() {
    ActiveRideCacheService.saveRideState(state);
  }

  void reset() {
    emit(ActiveRideState(progress: RideProgress()));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

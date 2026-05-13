part of '../../index.dart';

class ActiveRideCubit extends Cubit<ActiveRideState> with WidgetsBindingObserver {
  final RideStreamRepository repository;
  final GetCurrentRide getCurrentRideUsecase;
  StreamSubscription? _sub;
  bool _initialized = false;

  ActiveRideCubit({
    required this.repository,
    required this.getCurrentRideUsecase,
  }) : super(ActiveRideState(progress: RideProgress())) {
    _sub = repository.events.listen(_onEvent);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused && state.rideId != null) {
      ActiveRideCacheService.saveRideState(state);
    } else if (lifecycleState == AppLifecycleState.resumed &&
        state.rideId != null) {
      fetchCurrentRide(state.rideId!);
    }
  }

  void init() async {
    if (_initialized) return;
    _initialized = true;

    final cachedState = await ActiveRideCacheService.loadRideState();
    if (cachedState == null) return;

    // ✅ Always restore immediately
    emit(cachedState);

    final rideId = cachedState.rideId;

    // ✅ Then reconcile with backend
    if (rideId != null) {
      await fetchCurrentRide(rideId);
    }
  }

  Future<void> fetchCurrentRide(String rideId) async {
    try {
      final result = await getCurrentRideUsecase(
        GetCurrentRideParams(rideId: rideId),
      );

      result.fold((l) => {}, (ride) {
        final status = RideStatus.fromString(ride.status);

        if (status == RideStatus.idle) {
          // Don't reset a ride that's still in a valid search window —
          // the socket will deliver NoDriversFound when the search actually fails.
          if (state.status == RideStatus.searching && state.searchRemainingMs > 0) {
            return;
          }
          reset();
          ActiveRideCacheService.clearRideState();
          sl<RideMapCubit>().clearMarkers();
          return;
        }

        emit(
          state.copyWith(
            driver: ride.driver,
            location: ride.driverLocation,
            status: status,
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
    // Only persist if a ride is already active — saves before ride creation
    // have null rideId and can overwrite the correct cached state due to
    // fire-and-forget async writes completing out of order.
    if (state.rideId != null) _saveStateToCache();
  }

  void onRideCreated(String rideId, {int searchDurationMs = 3 * 60 * 1000}) {
    emit(
      state.copyWith(
        rideId: rideId,
        status: RideStatus.searching,
        searchDurationMs: searchDurationMs,
        searchStartedAtMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    _saveStateToCache();
  }

  void _onEvent(RideEvent event) {
    switch (event) {
      case RideCreated():
        emit(
          state.copyWith(rideId: event.rideId, status: RideStatus.searching),
        );
        _saveStateToCache();
      case RideAccepted():
        emit(
          state.copyWith(
            driver: event.driver,
            location: event.location,
            status: RideStatus.accepted,
          ),
        );
        _saveStateToCache();
      case RouteUpdated():
        emit(state.copyWith(routeUpdate: event.data));
        _saveStateToCache();
      case DriverLocationUpdated():
        emit(state.copyWith(candidateDrivers: event.data));
        _saveStateToCache();
      case DriverArrived():
        emit(state.copyWith(status: RideStatus.arrived));
        _saveStateToCache();
      case RideStarted():
        emit(
          state.copyWith(
            status: RideStatus.started,
            progress: RideProgress(fare: 0, distance: 0),
          ),
        );
        _saveStateToCache();
      case RideCompleted():
        reset();
        ActiveRideCacheService.clearRideState();
        sl<RideMapCubit>().clearMarkers();
      case NoDriversFound():
        reset();
        ActiveRideCacheService.clearRideState();
      case OnRideProgress():
        emit(state.copyWith(progress: event.data));
        _saveStateToCache();
      case OnDriverLocation():
        emit(state.copyWith(location: event.data));
        _saveStateToCache();
    }
  }

  void _saveStateToCache() {
    ActiveRideCacheService.saveRideState(state);
  }

  void reset() {
    _initialized = false;
    emit(ActiveRideState(progress: RideProgress()));
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    return super.close();
  }
}

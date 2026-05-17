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

        if (status == RideStatus.completed) {
          emit(state.copyWith(
            driver: ride.driver ?? state.driver,
            location: ride.driverLocation,
            status: RideStatus.completed,
          ));
          return;
        }

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

  Future<void> toggleUseBalance({required bool value}) async {
    emit(state.copyWith(useBalance: value));
    _saveStateToCache();

    final rideId = state.rideId;
    if (rideId == null) return; // no active ride yet — local preference only

    try {
      await repository.setUseBalance(rideId: rideId, useBalance: value);
    } catch (_) {
      emit(state.copyWith(useBalance: !value));
      _saveStateToCache();
    }
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
        final rideId = state.rideId;
        final useBalance = state.useBalance;
        emit(
          state.copyWith(
            driver: event.driver,
            location: event.location,
            status: RideStatus.accepted,
          ),
        );
        _saveStateToCache();
        AudioService().playSound('ride-accepted.mp3');
        // Re-send useBalance so the driver receives the correct value via
        // socket even if the passenger toggled it during searching (when
        // no driver was connected yet to receive the original event).
        if (useBalance && rideId != null) {
          repository.setUseBalance(rideId: rideId, useBalance: true);
        }
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
        emit(state.copyWith(status: RideStatus.completed));
        // State (fare, distance, driver) is intentionally preserved so the
        // ride summary sheet can display it. Cache cleared after user dismisses.
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

  Future<void> rateRide({
    required String rideId,
    required int rating,
    String? comment,
  }) async {
    try {
      await repository.rateRide(rideId: rideId, rating: rating, comment: comment);
    } catch (_) {}
  }

  void onRideSummaryDismissed() {
    reset();
    ActiveRideCacheService.clearRideState();
    sl<RideMapCubit>().clearMarkers();
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

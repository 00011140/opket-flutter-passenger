part of '../index.dart';

class RideStreamRepositoryImpl implements RideStreamRepository {
  final ActiveRideRemoteDatasource remoteDatasource;

  RideStreamRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<RideEvent> get events {
    final controller = StreamController<RideEvent>.broadcast();

    SocketService.instance.onRideAccepted.listen((data) {
      print("ACCEPTED 🫥🫥🫥🫥");
      print(data);
      final location = DriverLocation.fromMap(data['location']);

      controller.add(
        RideAccepted(driver: DriverModel.fromMap(data), location: location),
      );
    });

    SocketService.instance.onRouteUpdated.listen((data) {
      controller.add(RouteUpdated(data: RouteUpdate.fromJson(data)));
    });

    SocketService.instance.onRideStarted.listen((_) {
      controller.add(RideStarted());
    });

    SocketService.instance.onRideCompleted.listen((_) {
      controller.add(RideCompleted());
    });

    SocketService.instance.onNoDrivers.listen((_) {
      controller.add(NoDriversFound());
    });

    SocketService.instance.onCandidateDrivers.listen((data) {
      final drivers = (data['drivers'] as List)
          .map((d) => DriverLocation.fromMap(d))
          .toList();

      controller.add(DriverLocationUpdated(drivers));
    });

    SocketService.instance.onRideProgress.listen((data) {
      controller.add(OnRideProgress(RideProgress.fromJson(data)));
    });

    SocketService.instance.onDriverLocation.listen((data) {
      controller.add(
        OnDriverLocation(DriverLocation.fromMap(data as Map<String, dynamic>)),
      );
    });

    return controller.stream;
  }

  @override
  Future<Either<Failure, RideModel>> getCurrentRide(params) async {
    try {
      final result = await remoteDatasource.getCurrentRide(params);

      return Right(result);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}

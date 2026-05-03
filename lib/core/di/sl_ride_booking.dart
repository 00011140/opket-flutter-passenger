import 'package:opket/feat/ride_booking/data/ride_booking_remote_datasource.dart';
import 'package:opket/feat/ride_booking/data/ride_booking_repo_impl.dart';
import 'package:opket/feat/ride_booking/domain/repo/ride_booking_repo.dart';
import 'package:opket/feat/ride_booking/domain/usecases/cancel_ride.dart';
import 'package:opket/feat/ride_booking/domain/usecases/request_ride.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/location_confirmation_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_booking_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_map_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_validation_cubit.dart';

import 'sl.dart';

Future setUpRideBookingSl() async {
  // Use cases
  sl.registerLazySingleton(() => RequestRide(sl()));
  sl.registerLazySingleton(() => CancelRide(sl()));

  // Bloc/Cubit
  sl.registerFactory<RideBookingCubit>(
    () => RideBookingCubit(requestRideUsecase: sl(), cancelRideUsecase: sl()),
  );
  sl.registerFactory<RideValidationCubit>(
    () => RideValidationCubit(connectivityService: sl()),
  );

  sl.registerFactory<RideMapCubit>(() => RideMapCubit());
  sl.registerFactory<LocationConfirmationCubit>(
    () => LocationConfirmationCubit(),
  );

  // Repository
  sl.registerLazySingleton<RideBookingRepo>(() => RideBookingRepoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<RideBookingRemoteDatasource>(
    () => RideBookingRemoteDatasourceImpl(),
  );
}

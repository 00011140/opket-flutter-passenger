import 'package:opket/feat/active_ride/index.dart';

import 'sl.dart';

Future setUpActiveRideSl() async {
  // Repo
  sl.registerLazySingleton<RideStreamRepository>(
    () => RideStreamRepositoryImpl(remoteDatasource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentRide(sl()));

  // Data sources
  sl.registerLazySingleton<ActiveRideRemoteDatasource>(
    () => ActiveRideRemoteDatasourceImpl(),
  );

  // Bloc/Cubit
  sl.registerFactory(
    () => ActiveRideCubit(repository: sl(), getCurrentRideUsecase: sl()),
  );
  sl.registerFactory(() => GetCurrentRideCubit(sl()));
}

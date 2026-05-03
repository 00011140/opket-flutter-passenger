import 'package:opket/feat/ride_options/index.dart';

import 'sl.dart';

Future setUpRideOptionsSl() async {
  // Use cases
  sl.registerLazySingleton(() => GetRideOptions(sl()));

  // Bloc/Cubit
  sl.registerFactory<RideOptionsCubit>(
    () => RideOptionsCubit(getRideOptionsUsecase: sl()),
  );
  sl.registerFactory<SelectedRideOptionsCubit>(
    () => SelectedRideOptionsCubit(),
  );

  // Data sources
  sl.registerLazySingleton<RideOptionsRemoteDatasource>(
    () => RideOptionsRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<RideOptionsLocalDatasource>(
    () => RideOptionsLocalDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<RideOptionsRepo>(
    () => RideOptionsRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
}

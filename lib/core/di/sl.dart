import 'package:get_it/get_it.dart';
import 'package:opket/core/app_initialization/data/firebase_initializer.dart';
import 'package:opket/core/app_initialization/data/notification_initializer.dart';
import 'package:opket/core/app_initialization/domain/initialize_app.dart';
import 'package:opket/core/cubit/connectivity_cubit.dart';
import 'package:opket/core/cubit/services_cubit.dart';
import 'package:opket/core/di/sl_active_ride.dart';
import 'package:opket/core/di/sl_auth.dart';
import 'package:opket/core/di/sl_ride_booking.dart';
import 'package:opket/core/services/api_client.dart';
import 'package:opket/core/services/app_config_service.dart';
import 'package:opket/core/services/auth_storage.dart';
import 'package:opket/core/services/connectivity_service.dart';
import 'package:opket/core/services/otp_service.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';
import 'package:opket/feat/report/index.dart';
import 'package:opket/feat/report/services/report_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sl_ride_options.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerSingleton<AuthStorage>(AuthStorage(sl()));
  sl.registerSingleton<ApiClient>(ApiClient(tokenStorage: sl<AuthStorage>()));
  sl.registerSingleton<ReportCacheService>(ReportCacheService(prefs: sl()));
  sl.registerLazySingleton(() => ConnectivityService());
  sl.registerFactory(() => ConnectivityCubit(sl()));
  sl.registerFactory(() => LocationCubit());
  sl.registerSingleton<OtpService>(OtpService());

  // Initializers
  sl.registerLazySingleton<FirebaseInitializer>(
    () => FirebaseInitializerImpl(configService: AppConfigService()),
  );

  sl.registerLazySingleton<NotificationInitializer>(
    () => NotificationInitializerImpl(),
  );

  // Data sources
  sl.registerLazySingleton<ReportRemoteDatasource>(
    () => ReportRemoteDatasourceImpl(client: sl(), cacheService: sl()),
  );

  // Use case
  sl.registerLazySingleton(
    () =>
        InitializeApp(firebaseInitializer: sl(), notificationInitializer: sl()),
  );
  sl.registerLazySingleton(() => ReportAppInfo(sl()));

  // Repository
  sl.registerLazySingleton<ReportRepo>(() => ReportRepoImpl(sl()));

  sl.registerFactory<ServicesCubit>(() => ServicesCubit(sl()));

  await setUpAuthSl();
  await setUpRideBookingSl();
  await setUpActiveRideSl();
  await setUpRideOptionsSl();
}

import 'package:opket/feat/auth/data/auth_remote_datasource.dart';
import 'package:opket/feat/auth/data/auth_repository_impl.dart';
import 'package:opket/feat/auth/domain/repo/auth_repo.dart';
import 'package:opket/feat/auth/domain/usecases/register_user.dart';
import 'package:opket/feat/auth/domain/usecases/send_otp.dart';
import 'package:opket/feat/auth/domain/usecases/verify_otp.dart';
import 'package:opket/feat/auth/presentation/cubit/auth_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';

import 'sl.dart';

Future setUpAuthSl() async {
  // Use cases
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // Bloc/Cubit
  sl.registerFactory<OtpCubit>(
    () => OtpCubit(
      sendOtpUsecase: sl(),
      verifyOtpUsecase: sl(),
      registerUserUsecase: sl(),
    ),
  );

  sl.registerFactory<AuthCubit>(() => AuthCubit());

  // Repository
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(otpService: sl()),
  );
}

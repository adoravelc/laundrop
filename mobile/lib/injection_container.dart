import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Import semua file Auth yang udah kita bikin
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
// Import file-file laundry_service yang baru dibuat
import 'features/laundry_service/data/datasources/laundry_remote_data_source.dart';
import 'features/laundry_service/data/repositories/laundry_repository_impl.dart';
import 'features/laundry_service/domain/repositories/laundry_repository.dart';
import 'features/laundry_service/domain/get_services.dart';

// sl = Service Locator (Panggilan akrab untuk GetIt)
final sl = GetIt.instance;

Future<void> init() async {
  // ===========================================================================
  // 1. FITUR: AUTH
  // ===========================================================================

  // A. Use Cases
  // Kita pakai registerLazySingleton agar object ini baru dibuat saat pertama kali dipanggil (hemat RAM)
  sl.registerLazySingleton(() => LoginUser(sl()));

  // B. Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // C. Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // ===========================================================================
  // 2. EXTERNAL (Library Pihak Ketiga)
  // ===========================================================================

  // Kita daftarkan Dio di sini, biar nanti bisa disuntik token secara global
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  // 2. FITUR: LAUNDRY SERVICE (CATALOG)
  // ===========================================================================
  sl.registerLazySingleton(() => GetServices(sl()));
  sl.registerLazySingleton<LaundryRepository>(
    () => LaundryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LaundryRemoteDataSource>(
    () => LaundryRemoteDataSourceImpl(dio: sl()),
  );
}

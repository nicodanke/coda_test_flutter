import 'package:coda_flutter_test/interfaces/repositories/auth_repository.dart';
import 'package:coda_flutter_test/interfaces/repositories/client_repository.dart';
import 'package:coda_flutter_test/interfaces/services/auth_service.dart';
import 'package:coda_flutter_test/interfaces/services/client_service.dart';
import 'package:coda_flutter_test/repositories/auth_repository_impl.dart';
import 'package:coda_flutter_test/repositories/client_repository_impl.dart';
import 'package:coda_flutter_test/services/auth_service_impl.dart';
import 'package:coda_flutter_test/services/client_service_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class Dependencies{
  static final getIt = GetIt.instance;

  static FlutterSecureStorage get storage => GetIt.I.get();

  // Auth
  static AuthService get authService => GetIt.I.get();
  static AuthRepository get authRepository => GetIt.I.get();

  // Client
  static ClientService get clientService => GetIt.I.get();
  static ClientRepository get clientRepository => GetIt.I.get();

  static void registerDependencies() {

    getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

    // Auth
    getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

    // Client
    getIt.registerLazySingleton<ClientService>(() => ClientServiceImpl());
    getIt.registerLazySingleton<ClientRepository>(() => ClientRepositoryImpl());
  }
}

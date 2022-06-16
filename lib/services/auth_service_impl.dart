import 'dart:async';

import 'package:coda_flutter_test/interfaces/repositories/auth_repository.dart';
import 'package:coda_flutter_test/interfaces/services/auth_service.dart';
import 'package:coda_flutter_test/models/auth_user.dart';
import 'package:coda_flutter_test/models/exceptions/login_error.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  static final logger = Logger('AuthServiceImpl');

  AuthRepository get repository => GetIt.instance.get();

  FlutterSecureStorage get storage => GetIt.instance.get();

  @override
  Future<AuthUser?> login(String email, String password) async {
    if(email.isEmpty || password.isEmpty){
      throw const LoginError();
    }

    final currentUser = await repository.login(email, password);
    await storage.write(key: 'accessToken', value: currentUser?.accessToken ?? '');
    return currentUser;
  }

  @override
  Future<void> logout() async {
    storage.delete(key: 'accessToken');
  }
}

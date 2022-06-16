import 'dart:async';

import 'package:coda_flutter_test/models/auth_user.dart';

abstract class AuthService {

  Future<AuthUser?> login(String email, String password);

  Future<void> logout();
}

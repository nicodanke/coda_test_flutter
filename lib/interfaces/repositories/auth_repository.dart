import 'dart:async';

import 'package:coda_flutter_test/models/auth_user.dart';

abstract class AuthRepository {

  Future<AuthUser?> login(String email, String password);
  
}

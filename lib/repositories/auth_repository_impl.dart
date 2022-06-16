import 'package:coda_flutter_test/interfaces/repositories/auth_repository.dart';
import 'package:coda_flutter_test/models/auth_user.dart';
import 'package:coda_flutter_test/models/exceptions/api/api_error.dart';
import 'package:coda_flutter_test/models/exceptions/api/forbidden.dart';
import 'package:coda_flutter_test/models/exceptions/api/invalid_format.dart';
import 'package:coda_flutter_test/models/exceptions/api/not_found.dart';
import 'package:coda_flutter_test/models/exceptions/api/unauthenticated.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'dart:convert';

import 'package:logging/logging.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository{
  final baseUrl = 'https://agency-coda.uc.r.appspot.com';

  static final Logger _logger = Logger('AuthRepositoryImpl');

  @override
  Future<AuthUser?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/mia-auth/login');
    var res = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) {
      String errorMessage = data['error']['message'];
      int errorCode = data['error']['code'];
      _logger.severe('Register Error: $errorMessage');
      _getException(errorCode, errorMessage);
    } else {
      final response = data['response'] as Map<String, dynamic>;
      var currentUser = AuthUser.fromJson(response);
      return currentUser;
    }
    return null;
  }

  Exception _getException(int statusCode, String message) {
    if (statusCode == 400) {
      throw const InvalidFormat();
    }
    if (statusCode == 401) {
      throw const Unauthenticated();
    }
    if (statusCode == 403) {
      throw const Forbidden();
    }
    if (statusCode == 404) {
      throw const NotFound();
    }
    throw ApiException(message: message);
  }
}
import 'package:coda_flutter_test/presentation/clients/clientes_page.dart';
import 'package:coda_flutter_test/presentation/login/login_page.dart';
import 'package:flutter/material.dart';

abstract class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case PageRoutes.login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case PageRoutes.clients:
        return MaterialPageRoute(
          builder: (context) => const ClientsPage(),
        );
      default:
        return throw const LoginPage();
    }
  }
}

abstract class PageRoutes {
  static const String login = 'login';
  static const String clients = 'clients';
}

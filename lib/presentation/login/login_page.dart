import 'package:coda_flutter_test/presentation/login/login_form/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/login/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: size.width/2 + 80,
            left: 0,
            child: Image.asset(
              'assets/login/background2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/login/background3.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: 500,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/login/logo.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20,),
                    const LoginForm(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

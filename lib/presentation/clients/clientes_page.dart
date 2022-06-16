import 'package:coda_flutter_test/presentation/clients/clients_list/client_list.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/clients/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: size.width/2,
            right: 0,
            child: Image.asset(
              'assets/clients/background2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/clients/background3.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/clients/background4.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Center(
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 34, bottom: 26),
                          child: Image.asset(
                            'assets/clients/small-logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const ClientsList(),
                      ],
                    ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

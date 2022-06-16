import 'package:coda_flutter_test/dependencies.dart';
import 'package:coda_flutter_test/presentation/main.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  Dependencies.registerDependencies();
  GetRef.registerDependencies();
  runApp(const CodaApp());
}

import 'package:coda_flutter_test/dependencies.dart';
import 'package:coda_flutter_test/presentation/main.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Dependencies.registerDependencies();
  GetRef.registerDependencies();
  runApp(const CodaApp());
}

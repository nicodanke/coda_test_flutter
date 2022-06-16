import 'dart:async';

import 'package:coda_flutter_test/models/client.dart';

abstract class ClientService {

  Future<List<Client>> findAll();

  Future<Client?> save(ClientCreate clientCreate);

  Future<Client?> update(ClientCreate clientCreate);

  Future<bool> delete(int id);
}

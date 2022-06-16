import 'dart:async';

import 'package:coda_flutter_test/interfaces/repositories/client_repository.dart';
import 'package:coda_flutter_test/interfaces/services/client_service.dart';
import 'package:coda_flutter_test/models/client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

@LazySingleton(as: ClientService)
class ClientServiceImpl implements ClientService {
  static final logger = Logger('ClientServiceImpl');

  ClientRepository get repository => GetIt.instance.get();  

  @override
  Future<List<Client>> findAll() async {
    return await repository.findAll();
  }
  
  @override
  Future<Client?> save(ClientCreate clientCreate) async {
    return await repository.save(clientCreate);
  }
  
  @override
  Future<Client?> update(ClientCreate clientCreate) async {
    return await repository.update(clientCreate);
  }
  
  @override
  Future<bool> delete(int id) async {
    return await repository.delete(id);
  }
}

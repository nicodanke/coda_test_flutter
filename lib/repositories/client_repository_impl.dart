import 'package:coda_flutter_test/interfaces/repositories/client_repository.dart';
import 'package:coda_flutter_test/interfaces/services/auth_service.dart';
import 'package:coda_flutter_test/models/client.dart';
import 'package:coda_flutter_test/models/exceptions/api/api_error.dart';
import 'package:coda_flutter_test/models/exceptions/api/forbidden.dart';
import 'package:coda_flutter_test/models/exceptions/api/invalid_format.dart';
import 'package:coda_flutter_test/models/exceptions/api/not_found.dart';
import 'package:coda_flutter_test/models/exceptions/api/unauthenticated.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'dart:convert';

import 'package:logging/logging.dart';

@LazySingleton(as: ClientRepository)
class ClientRepositoryImpl extends ClientRepository{
  final baseUrl = 'https://agency-coda.uc.r.appspot.com';

  static final Logger _logger = Logger('ClientRepositoryImpl');

  AuthService get authService => GetIt.instance.get();

  FlutterSecureStorage get storage => GetIt.instance.get();

  @override
  Future<List<Client>> findAll() async {
    _logger.info('Getting all clients');
    var keepGetting = true;
    var nextPageUrl = '';
    List<Client> clients = [];
    try {      
      while(keepGetting){
        final url = Uri.parse('$baseUrl/client/list$nextPageUrl');
        final accessToken = await storage.read(key: 'accessToken');
        Map<String, String> headers = {
          "authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        };
        var res = await http.post(
          url,
          body: jsonEncode({}),
          headers: headers,
        );
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (!data['success']) {
          String errorMessage = data['error']['message'];
          int errorCode = data['error']['code'];
          _logger.severe('Error: $errorMessage');
          _getException(errorCode, errorMessage);
          keepGetting = false;
        } else {
          final response = data['response'] as Map<String, dynamic>;
          if(response['next_page_url'] == null){
            keepGetting = false;
          } else {
            nextPageUrl = response['next_page_url'].toString().substring(1);
          }
          final json = jsonEncode(response['data']);
          clients = [...clients, ...clientsFromJson(json.toString())];
        }
      }
      _logger.info('Get all clients successful');
      return clients;
    } on Exception catch (e){
      _logger.severe('Register Error: $e');
      clients = [];
    }
    _logger.severe('Get all clients failed');
    return clients;
  }
  
  @override
  Future<Client?> save(ClientCreate clientCreate) async {
    _logger.info('Saving new client');
    final url = Uri.parse('$baseUrl/client/save');
    final accessToken = await storage.read(key: 'accessToken');
    Map<String, String> headers = {
      "authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    var res = await http.post(
      url,
      body: jsonEncode(clientCreate.toJson()),
      headers: headers,
    );

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) {
      String errorMessage = data['error']['message'];
      int errorCode = data['error']['code'];
      _logger.severe('Error: $errorMessage');
      _getException(errorCode, errorMessage);
    } else {
      final response = data['response'] as Map<String, dynamic>;
      _logger.info('Saving new client successfully');
      return Client.fromJson(response);
    }
    return null;
  }
  
  @override
  Future<Client?> update(ClientCreate clientCreate) async {
    _logger.info('Updating client with id: ${clientCreate.id}');
    final url = Uri.parse('$baseUrl/client/save');
    final accessToken = await storage.read(key: 'accessToken');
    Map<String, String> headers = {
      "authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    var res = await http.post(
      url,
      body: jsonEncode(clientCreate.toJson()),
      headers: headers,
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) {
      String errorMessage = data['error']['message'];
      int errorCode = data['error']['code'];
      _logger.severe('Error: $errorMessage');
      _getException(errorCode, errorMessage);
    } else {
      final response = data['response'] as Map<String, dynamic>;
      _logger.info('Client with id: ${clientCreate.id} updated successfully');
      return Client.fromJson(response);
    }
    _logger.severe('Error: updating client with id: ${clientCreate.id}');
    return null;
  }
  
  @override
  Future<bool> delete(int id) async {
    _logger.info('Deleting client with id: $id');
    final url = Uri.parse('$baseUrl/client/remove/$id');
    final accessToken = await storage.read(key: 'accessToken');
    Map<String, String> headers = {
      "authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    var res = await http.delete(
      url,
      body: jsonEncode({}),
      headers: headers,
    );

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (!data['success']) {
      String errorMessage = data['error']['message'];
      int errorCode = data['error']['code'];
      _logger.severe('Error: $errorMessage');
      _getException(errorCode, errorMessage);
    } else {
      final response = data['response'];
      return response;
    }
    _logger.severe('Deleting client with id: $id failed');
    return false;
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
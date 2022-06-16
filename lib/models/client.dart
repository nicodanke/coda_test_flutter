import 'dart:convert';

import 'package:equatable/equatable.dart';

List<Client> clientsFromJson(String str) => List<Client>.from(jsonDecode(str).map((e) => Client.fromJson(e)));
String clientsToJson(List<Client> data) => jsonEncode(List<dynamic>.from(data.map((e) => e.toJson())));

class Client extends Equatable{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String photo;
  final String caption;

  const Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.photo,
    required this.caption,
  });
  
  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    address,
    photo,
    caption,
  ];

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json['id'],
    firstName: json['firstname'],
    lastName: json['lastname'],
    email: json['email'],
    address: json['address'],
    photo: json['photo'],
    caption: json['caption'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    'address': address,
    'photo': photo,
    'caption': caption,
  };
}

class ClientCreate{
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String photo;
  final String caption;

  const ClientCreate({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.address = '',
    this.photo = '',
    this.caption = '',
    this.id,
  });

  Map<String, dynamic> toJson() {
    if(id == null){
      return {
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'address': address,
        'photo': photo,
        'caption': caption,
      };
    }
    return {
        'id': id!,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'address': address,
        'photo': photo,
        'caption': caption,
      };
  }
}
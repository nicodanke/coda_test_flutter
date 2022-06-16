import 'package:equatable/equatable.dart';

class ApiException extends Equatable implements Exception{
  final String message;
  const ApiException({required this.message});

  @override
  List<Object?> get props => [];
}

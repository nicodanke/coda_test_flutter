import 'package:equatable/equatable.dart';

class InvalidFields extends Equatable implements Exception{
  const InvalidFields();

  @override
  List<Object?> get props => [];
}

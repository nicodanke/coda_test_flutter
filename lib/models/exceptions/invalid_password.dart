import 'package:equatable/equatable.dart';

class InvalidPassword extends Equatable implements Exception{
  const InvalidPassword();

  @override
  List<Object?> get props => [];
}

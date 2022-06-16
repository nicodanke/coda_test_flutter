import 'package:equatable/equatable.dart';

class InvalidMail extends Equatable implements Exception{
  const InvalidMail();

  @override
  List<Object?> get props => [];
}

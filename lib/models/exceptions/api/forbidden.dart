import 'package:equatable/equatable.dart';

class Forbidden extends Equatable implements Exception{
  const Forbidden();

  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';

class Unauthenticated extends Equatable implements Exception{
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}

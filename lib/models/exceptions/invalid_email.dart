import 'package:equatable/equatable.dart';

class InvalidEmail extends Equatable implements Exception{
  const InvalidEmail();

  @override
  List<Object?> get props => [];
}

import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:equatable/equatable.dart';

class ClientDialogState extends Equatable {
  
  final FormSubmissionStatus submitStatus;
  final String firstName;
  final String lastName;
  final String email;

  const ClientDialogState({
    this.submitStatus = const InitialFormSubmissionStatus(),
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  ClientDialogState copyWith({
    FormSubmissionStatus? submitStatus,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return ClientDialogState(
      submitStatus: submitStatus ?? this.submitStatus,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
        submitStatus,
        firstName,
        lastName,
        email,
      ];
}

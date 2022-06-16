import 'package:coda_flutter_test/models/auth_user.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final AuthUser? authUser;
  final FormSubmissionStatus submitStatus;
  final String password;
  final String email;

  const LoginState({
    this.email = '',
    this.password = '',
    this.authUser,
    this.submitStatus = const InitialFormSubmissionStatus(),
  });

  LoginState copyWith({
    AuthUser? authUser,
    String? email,
    String? password,
    FormSubmissionStatus? submitStatus,
    bool removeUser = false,
  }) {
    return LoginState(
      authUser: removeUser ? null : (authUser ?? this.authUser),
      submitStatus: submitStatus ?? this.submitStatus,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [
        authUser,
        submitStatus,
        email,
        password,
      ];
}

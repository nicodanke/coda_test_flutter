import 'dart:async';

import 'package:binder/binder.dart';
import 'package:binder/binder.dart' as binder;
import 'package:coda_flutter_test/interfaces/services/auth_service.dart';
import 'package:coda_flutter_test/models/auth_user.dart';
import 'package:coda_flutter_test/models/exceptions/login_error.dart';
import 'package:coda_flutter_test/presentation/login/state_logic/login_state.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:get_it/get_it.dart';

class LoginLogic with Logic{
  @override
  final Scope scope;

  final AuthService service = GetIt.I.get();
  StreamSubscription? streamSub;

  StateRef<LoginState> get stateRef => GetIt.I.get();

  LoginLogic({
    required this.scope,
  });

  Future<AuthUser?> login() async {
    write(
      stateRef,
      read(stateRef).copyWith(
        submitStatus: FormSubmitting(),
      ),
    );
    String email = read(stateRef.select((state) => state.email));
    String password = read(stateRef.select((state) => state.password));
    try {
      var login = await service.login(email, password);
      if (login != null) {
        write(
          stateRef,
          read(stateRef).copyWith(
            authUser: login,
          ),
        );
        return login;
      }
      write(
        stateRef,
        read(stateRef).copyWith(
          submitStatus: const SubmissionFailed(error: LoginError()),
        ),
      );
    } on Exception catch (e){
      write(
        stateRef,
        read(stateRef).copyWith(
          submitStatus: SubmissionFailed(error: e),
        ),
      );
    }
  }

  Future<void> logout() async {
    await service.logout();

    write(stateRef, read(stateRef).copyWith(removeUser: true));
  }

  void setPassword(String value){
    write(stateRef, read(stateRef).copyWith(password: value));
  }

  void setEmail(String value){
    write(stateRef, read(stateRef).copyWith(email: value));
  }

  void restSubmit(){
    write(stateRef, read(stateRef).copyWith(submitStatus: const InitialFormSubmissionStatus()));
  }
}

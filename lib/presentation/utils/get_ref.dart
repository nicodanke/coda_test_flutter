import 'package:binder/binder.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_dialog_logic.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_dialog_state.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_logic.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_state.dart';
import 'package:coda_flutter_test/presentation/login/state_logic/login_logic.dart';
import 'package:coda_flutter_test/presentation/login/state_logic/login_state.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

class GetRef{
  static final getIt = GetIt.instance;

  // Login
  static StateRef<LoginState> get loginStateRef => GetIt.I.get();
  static LogicRef<LoginLogic> get loginLogic => GetIt.I.get();

  // Client
  static StateRef<ClientState> get clientStateRef => GetIt.I.get();
  static LogicRef<ClientLogic> get clientLogic => GetIt.I.get();

  // Client Dialog
  static StateRef<ClientDialogState> get clientDialogStateRef => GetIt.I.get();
  static LogicRef<ClientDialogLogic> get clientDialogLogic => GetIt.I.get();

  // Client Computed
  static ClientComputed get clientComputed => GetIt.I.get();

  static void registerDependencies() {
    // Login
    getIt.registerLazySingleton<StateRef<LoginState>>(() => StateRef(const LoginState()));
    getIt.registerLazySingleton<LogicRef<LoginLogic>>(() => LogicRef((scope) => LoginLogic(scope: scope)));

    // Client
    getIt.registerLazySingleton<StateRef<ClientState>>(() => StateRef(const ClientState()));
    getIt.registerLazySingleton<LogicRef<ClientLogic>>(() => LogicRef((scope) => ClientLogic(scope: scope)));

    // Client Dialog
    getIt.registerLazySingleton<StateRef<ClientDialogState>>(() => StateRef(const ClientDialogState()));
    getIt.registerLazySingleton<LogicRef<ClientDialogLogic>>(() => LogicRef((scope) => ClientDialogLogic(scope: scope)));

    // Client Computed
    getIt.registerLazySingleton<ClientComputed>(() => ClientComputed());
  }
}

abstract class GetStatus extends Equatable {
  const GetStatus();

  @override
  List<Object?> get props => [];
}

class InitialGetStatus extends GetStatus {
  const InitialGetStatus();
}

class GettingStatus extends GetStatus {}

class GetSuccess extends GetStatus {}

class GetFailed extends GetStatus {
  final Exception error;

  const GetFailed({required this.error});

  @override
  List<Object?> get props => [error.runtimeType];
}

abstract class FormSubmissionStatus extends Equatable {
  const FormSubmissionStatus();

  @override
  List<Object?> get props => [];
}

class InitialFormSubmissionStatus extends FormSubmissionStatus {
  const InitialFormSubmissionStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Exception error;

  const SubmissionFailed({required this.error});

  @override
  List<Object?> get props => [error.runtimeType];
}

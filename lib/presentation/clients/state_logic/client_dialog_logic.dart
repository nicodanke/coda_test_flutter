import 'package:binder/binder.dart';
import 'package:coda_flutter_test/interfaces/services/client_service.dart';
import 'package:coda_flutter_test/models/client.dart';
import 'package:coda_flutter_test/models/exceptions/invalid_fields.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_dialog_state.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_logic.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:get_it/get_it.dart';

class ClientDialogLogic with Logic{
  @override
  final Scope scope;

  final ClientService service = GetIt.I.get();

  StateRef<ClientDialogState> get stateRef => GetIt.I.get();

  LogicRef<ClientLogic> get clientLogic => GetIt.I.get();

  ClientDialogLogic({
    required this.scope,
  });

  void setFields({Client? client}){
    if(client == null){
      write(stateRef, read(stateRef).copyWith(firstName: '', lastName: '', email: '',));
    }else{
      write(stateRef, read(stateRef).copyWith(firstName: client.firstName, lastName: client.lastName, email: client.email,));
    }
  }

  void setFirstName(String value){
    write(stateRef, read(stateRef).copyWith(firstName: value));
  }

  void setLastName(String value){
    write(stateRef, read(stateRef).copyWith(lastName: value));
  }

  void setEmail(String value){
    write(stateRef, read(stateRef).copyWith(email: value));
  }

  void submit() async{
    write(stateRef, read(stateRef).copyWith(submitStatus: FormSubmitting()));
    final firstName = read(stateRef).firstName;
    final lastName = read(stateRef).lastName;
    final email = read(stateRef).email;

    if(firstName.isEmpty || lastName.isEmpty || email.isEmpty){
      write(stateRef, read(stateRef).copyWith(submitStatus: const SubmissionFailed(error: InvalidFields())));
      return;
    }

    final clientCreate = ClientCreate(firstName: firstName, lastName: lastName, email: email,);
    try{
      final client = await service.save(clientCreate);
      if(client != null){
        use(clientLogic).load();
      }
      write(stateRef, read(stateRef).copyWith(submitStatus: SubmissionSuccess()));
    } on Exception catch (e){
      write(stateRef, read(stateRef).copyWith(submitStatus: SubmissionFailed(error: e)));
    }
  }

  void submitUpdate(int id) async{
    write(stateRef, read(stateRef).copyWith(submitStatus: FormSubmitting()));
    final firstName = read(stateRef).firstName;
    final lastName = read(stateRef).lastName;
    final email = read(stateRef).email;

    if(firstName.isEmpty || lastName.isEmpty || email.isEmpty){
      write(stateRef, read(stateRef).copyWith(submitStatus: const SubmissionFailed(error: InvalidFields())));
      return;
    }

    final clientCreate = ClientCreate(id: id, firstName: firstName, lastName: lastName, email: email,);
    try{
      final client = await service.update(clientCreate);
      if(client != null){
        use(clientLogic).load();
      }
      write(stateRef, read(stateRef).copyWith(submitStatus: SubmissionSuccess()));
    } on Exception catch (e){
      write(stateRef, read(stateRef).copyWith(submitStatus: SubmissionFailed(error: e)));
    }
  }

  void resetSubmit(){
    write(stateRef, read(stateRef).copyWith(submitStatus: const InitialFormSubmissionStatus()));
  }
}

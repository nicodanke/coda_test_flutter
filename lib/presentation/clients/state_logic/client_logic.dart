import 'dart:async';

import 'package:binder/binder.dart';
import 'package:coda_flutter_test/interfaces/services/client_service.dart';
import 'package:coda_flutter_test/models/exceptions/delete_error.dart';
import 'package:coda_flutter_test/presentation/clients/state_logic/client_state.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:get_it/get_it.dart';

class ClientLogic with Logic implements Loadable{
  @override
  final Scope scope;

  final ClientService service = GetIt.I.get();

  StateRef<ClientState> get stateRef => GetIt.I.get();

  ClientLogic({
    required this.scope,
  });

  void setSearch(String value){
    write(stateRef, read(stateRef).copyWith(search: value, page: 1));
  }

  void loadNextPage(){
    int actualPage = read(stateRef).page;
    final search = read(stateRef).search;
    var filteredList = read(stateRef).clients.where((cl) => cl.firstName.toLowerCase().contains(search.toLowerCase()) || cl.lastName.toLowerCase().contains(search.toLowerCase()) || cl.email.toLowerCase().contains(search.toLowerCase())).toList();
    final totalPages = filteredList.length / 5;
    if(actualPage>=totalPages){
      actualPage = 1;
    }else{
      actualPage++;
    }
    write(stateRef, read(stateRef).copyWith(page: actualPage));
  }
  
  @override
  Future<void> load() async{
    write(stateRef, read(stateRef).copyWith(getStatus: GettingStatus()));
    try{
      final clients = await service.findAll();
      write(stateRef, read(stateRef).copyWith(clients: clients, getStatus: GetSuccess()));
    } on Exception catch (e){
      write(stateRef, read(stateRef).copyWith(getStatus: GetFailed(error: e)));
    }
  }

  void delete(int id) async{
    write(stateRef, read(stateRef).copyWith(submitStatusDelete: FormSubmitting()));
    try{
      bool result = await service.delete(id);
      if(result){
        load();
        write(stateRef, read(stateRef).copyWith(submitStatusDelete: SubmissionSuccess()));
        return;
      }
      write(stateRef, read(stateRef).copyWith(submitStatusDelete: const SubmissionFailed(error: DeleteError())));
    } on Exception catch(e){
      write(stateRef, read(stateRef).copyWith(submitStatusDelete: SubmissionFailed(error: e)));
    }
  }

  void resetSubmit(){
    write(stateRef, read(stateRef).copyWith(submitStatusDelete: const InitialFormSubmissionStatus()));
  }
}

import 'package:binder/binder.dart';
import 'package:coda_flutter_test/models/client.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:equatable/equatable.dart';

class ClientState extends Equatable {
  final List<Client> clients;
  final FormSubmissionStatus submitStatusDelete;
  final GetStatus getStatus;
  final String search;
  final int page;

  const ClientState({
    this.clients = const [],
    this.submitStatusDelete = const InitialFormSubmissionStatus(),
    this.getStatus = const InitialGetStatus(),
    this.search = '',
    this.page = 1,
  });

  ClientState copyWith({
    List<Client>? clients,
    FormSubmissionStatus? submitStatusCreate,
    FormSubmissionStatus? submitStatusDelete,
    FormSubmissionStatus? submitStatusUpdate,
    GetStatus? getStatus,
    String? search,
    int? page,
  }) {
    return ClientState(
      clients: clients ?? this.clients,
      submitStatusDelete: submitStatusDelete ?? this.submitStatusDelete,
      getStatus: getStatus ?? this.getStatus,
      search: search ?? this.search,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
        clients,
        submitStatusDelete,
        getStatus,
        search,
      ];
}

class ClientComputed{
  Watchable<List<Client>> getClientsByChunks(){
    return Computed(
      (watch) {
        final clients = watch(GetRef.clientStateRef.select((state) => state.clients));
        final page = watch(GetRef.clientStateRef.select((state) => state.page));
        final search = watch(GetRef.clientStateRef.select((state) => state.search));
        var filteredList = clients;
        if(search.isNotEmpty){
          filteredList = clients.where((cl) => cl.firstName.toLowerCase().contains(search.toLowerCase()) || cl.lastName.toLowerCase().contains(search.toLowerCase()) || cl.email.toLowerCase().contains(search.toLowerCase())).toList();
        }
        const pageSize = 5;
        if(page * pageSize > filteredList.length){
          return filteredList.sublist((page - 1) * pageSize, filteredList.length);
        }
        return filteredList.sublist((page - 1) * pageSize, page * pageSize);
      }
    );
  }
}

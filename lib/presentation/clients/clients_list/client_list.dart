import 'package:another_flushbar/flushbar.dart';
import 'package:binder/binder.dart';
import 'package:coda_flutter_test/models/client.dart';
import 'package:coda_flutter_test/models/exceptions/delete_error.dart';
import 'package:coda_flutter_test/presentation/clients/clients_list/add_update_dialog.dart';
import 'package:coda_flutter_test/presentation/clients/clients_list/loading_clients.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:flutter/material.dart';

class ClientsList extends StatelessWidget {
  const ClientsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'CLIENTS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 24,),
            const ClientSearch(),
            LogicLoader(
              refs: [GetRef.clientLogic],
              builder: (context, loading, child) {
                if (loading) {
                  return const LoadingClientShimmer();
                }
                final clients = context.watch(GetRef.clientComputed.getClientsByChunks());
                return Container(
                  padding: const EdgeInsets.only(top: 18),
                  height: 510,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clients.length,
                    itemBuilder: (BuildContext context, int index) {
                      final name = clients.elementAt(index).firstName;
                      final lastname = clients.elementAt(index).lastName;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade800, width: 1,),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: clients.elementAt(index).photo.isNotEmpty
                          ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              clients.elementAt(index).photo,
                            ),
                          ) 
                          : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.grey.shade700,),
                          ),
                          title: Text(
                            '$name $lastname',
                          ),
                          subtitle: Text(
                            clients.elementAt(index).email,
                          ),
                          trailing: DropdownMenuButton(client: clients.elementAt(index),),
                          tileColor: Colors.white,
                          
                        ),
                      );
                    }
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: ClientLoadMoreButton(),
            ),
          ],
        ),
      );
  }
}

class ClientSearch extends StatelessWidget {
  const ClientSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Search...',
                alignLabelWithHint: true,
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 39,
                  minWidth: 39,
                ),
              ),
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (value) => context.use(GetRef.clientLogic).setSearch(value),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () async {
                context.use(GetRef.clientDialogLogic).setFields();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AddUpdateClientDialog(
                      title: 'Add new client',
                      onPressedSave: () => context.use(GetRef.clientDialogLogic).submit(),
                    );
                  }
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                child: Text(
                  'ADD NEW', 
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientLoadMoreButton extends StatelessWidget {
  const ClientLoadMoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          context.use(GetRef.clientLogic).loadNextPage();
        },
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: const Center(
            child: Text(
              style: TextStyle(fontSize: 14),
              'LOAD MORE',
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownMenuButton extends StatefulWidget{
  final Client client;
  
  const DropdownMenuButton({required this.client, Key? key}) : super(key: key);

  @override
  DropdownMenuButtonState createState() => DropdownMenuButtonState();
}

class DropdownMenuButtonState extends State<DropdownMenuButton>{
  OverlayEntry? _overlayEntry;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlayEntry(context);
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var height = MediaQuery.of(context).size.height;
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) => Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _overlayEntry!.remove();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              left: offset.dx - 80,
              top: offset.dy + size.height - 55.0,
              width: 156,
              height: 125,
              child: Material(
                color: Colors.transparent,
                elevation: 12.0,
                child: Container(
                  color: Colors.transparent,
                  constraints: BoxConstraints(maxHeight: height * 0.75),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 156,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(Icons.edit, color: Colors.white,),
                              ),
                              Text('Edit', style: TextStyle(color: Colors.white, ),),
                            ],
                          ),
                        ),
                        onTap: () async {
                          _overlayEntry!.remove();
                          context.use(GetRef.clientDialogLogic).setFields(client: widget.client);
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AddUpdateClientDialog(
                                title: 'Edit client',
                                client: widget.client,
                                onPressedSave: () => context.use(GetRef.clientDialogLogic).submitUpdate(widget.client.id),
                              );
                            }
                          );
                        },
                      ),
                      const SizedBox(height: 5,),
                      GestureDetector(
                        child: Container(
                          width: 156,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(Icons.delete, color: Colors.white,),
                              ),
                              Text('Delete', style: TextStyle(color: Colors.white, ),),
                            ],
                          ),
                        ),
                        onTap: () async {
                          _overlayEntry!.remove();
                          context.use(GetRef.clientLogic).delete(widget.client.id);
                        },
                      ),
                      // Handlers
                      StateListener(
                        watchable: GetRef.clientStateRef.select((state) => state.submitStatusDelete),
                        onStateChanged: _handleDeletion,
                        child: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  void _handleDeletion(BuildContext context, FormSubmissionStatus status) {
    if (status is SubmissionFailed) {
      String errorMessage = status.error.toString();
      if(status.error is DeleteError) errorMessage = 'Error deleting client';
      Flushbar(
        title: 'Error:',
        message:  errorMessage,
        duration: const Duration(seconds: 3),
      ).show(context);
    }
    if (status is SubmissionSuccess){
      Flushbar(
        message: 'Client deleted',
        duration: const Duration(seconds: 3),
      ).show(context);
    }
    context.use(GetRef.clientLogic).resetSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Overlay.of(context)!.insert(_overlayEntry!);
      }, 
      icon: const Icon(Icons.more_vert),
    );
  }
}

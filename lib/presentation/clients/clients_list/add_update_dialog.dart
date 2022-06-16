import 'dart:io';

import 'package:binder/binder.dart';
import 'package:coda_flutter_test/models/client.dart';
import 'package:coda_flutter_test/models/exceptions/invalid_fields.dart';
import 'package:coda_flutter_test/models/exceptions/invalid_mail.dart';
import 'package:coda_flutter_test/models/validators/validators.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:coda_flutter_test/presentation/utils/snackbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

class AddUpdateClientDialog extends StatefulWidget {
  final Client? client;
  final String title;
  final void Function() onPressedSave;

  const AddUpdateClientDialog({required this.title, required this.onPressedSave, this.client, Key? key}) : super(key: key);

  @override
  AddUpdateClientDialogState createState() => AddUpdateClientDialogState();
}

class AddUpdateClientDialogState extends State<AddUpdateClientDialog>{
  static final Logger _logger = Logger('AddUpdateClientDialog');
  
  File? image;

  Future pickImage() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch(e){
      _logger.severe('Failed to pick an image: $e');
    }
    
  }

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          actionsPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
          titlePadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 34),
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 17),
          ),
          content: Container(
            color: const Color(0xD4FDFDF9),
            padding: EdgeInsets.zero,
            width: size.width * 0.8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 19),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(100),
                        padding: const EdgeInsets.all(6),
                        color: const Color(0xFFE4F353),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                          child: widget.client == null || widget.client!.photo.isEmpty
                          ? GestureDetector(
                            child: image != null 
                            ? ClipOval(
                              child: Image.file(
                                image!,
                                width: 119,
                                height: 119,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Container(
                              height: 119,
                              width: 119,
                              color: Colors.transparent,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined, color: Colors.grey.shade500, size: 38,),
                                    const SizedBox(height: 10,),
                                    Text('Upload Image', style: TextStyle(color: Colors.grey.shade500, fontSize: 13),),
                                  ],
                                )
                              ),
                            ),
                            onTap: () => pickImage(),
                          )
                          : CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              widget.client!.photo,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Fields
                    const SizedBox(height: 20,),
                    ClientTextField(
                      label: 'First name*',
                      initialValue: widget.client?.firstName ?? '',
                      validateFunction: (value) => FieldValidator.validateNotEmpty(value),
                      onChanged: (value) {
                        context.use(GetRef.clientDialogLogic).setFirstName(value);
                      },
                    ),
                    ClientTextField(
                      label: 'Last name*',
                      initialValue: widget.client?.lastName ?? '',
                      validateFunction: (value) => FieldValidator.validateNotEmpty(value),
                      onChanged: (value) {
                        context.use(GetRef.clientDialogLogic).setLastName(value);
                      },
                    ),
                    ClientTextField(
                      label: 'Email address*',
                      initialValue: widget.client?.email ?? '',
                      validateFunction: (value) => FieldValidator.validateEmail(value),
                      onChanged: (value) {
                        context.use(GetRef.clientDialogLogic).setEmail(value);
                      },
                    ),
                  ],
                )
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Cancel', 
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: widget.onPressedSave,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: const Center(
                        child: Text(
                          'SAVE', 
                          style: TextStyle(fontSize: 14,),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Handlers
            StateListener(
              watchable: GetRef.clientDialogStateRef.select((state) => state.submitStatus),
              onStateChanged: _handleSubmition,
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmition(BuildContext context, FormSubmissionStatus status) {
    if (status is SubmissionFailed) {
      String errorMessage = 'Error adding new client';
      if(status.error is InvalidFields) errorMessage = 'Please complete all fields';
      if(status.error is InvalidMail) errorMessage = 'Please enter a valid mail';
      Snackbar.triggerSnackbar(context: context, message: errorMessage, title: 'Error:');
    }
    if (status is SubmissionSuccess){
      Navigator.of(context).pop();
    }
    context.use(GetRef.clientDialogLogic).resetSubmit();
  }
}

class ClientTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final String? Function(String?)? validateFunction;
  final Function(String) onChanged;
  const ClientTextField({required this.label, required this.initialValue, required this.onChanged, this.validateFunction, Key? key}) : super(key: key);

  @override
  ClientTextFieldState createState() => ClientTextFieldState();
}

class ClientTextFieldState extends State<ClientTextField>{

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: widget.initialValue,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
         labelText: widget.label,
         focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        enableSuggestions: false,
        autocorrect: false,
        autovalidateMode: widget.validateFunction == null ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
        validator: widget.validateFunction,
        onChanged: widget.onChanged,
      ),
    );
  }
}
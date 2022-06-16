import 'package:another_flushbar/flushbar.dart';
import 'package:binder/binder.dart';
import 'package:coda_flutter_test/models/auth_user.dart';
import 'package:coda_flutter_test/models/exceptions/api/api_error.dart';
import 'package:coda_flutter_test/models/exceptions/login_error.dart';
import 'package:coda_flutter_test/models/validators/validators.dart';
import 'package:coda_flutter_test/presentation/utils/get_ref.dart';
import 'package:coda_flutter_test/presentation/utils/route_generator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('LOG IN', style: TextStyle(letterSpacing: 2.5),),
              const SizedBox(height: 38),
              const EmailTextField(),
              const SizedBox(height: 25),
              const PasswordTextField(),
              const SizedBox(height: 40),
              const LoginSubmitButton(),

              // Handlers
              StateListener(
                watchable: GetRef.loginStateRef.select((state) => state.submitStatus),
                onStateChanged: _handleSubmitFail,
                child: const SizedBox.shrink(),
              ),
              StateListener(
                watchable: GetRef.loginStateRef.select((state) => state.authUser),
                onStateChanged: _handleLogin,
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmitFail(BuildContext context, FormSubmissionStatus status) {
    if (status is SubmissionFailed) {
      if(status.error is LoginError){
        Flushbar(
          message:  "Wrong user or password",
          duration: const Duration(seconds: 3),
        ).show(context);
      } else if (status.error is ApiException){
        ApiException error = status.error as ApiException;
        Flushbar(
          message:  error.message,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
      context.use(GetRef.loginLogic).restSubmit();
    }
  }

  void _handleLogin(BuildContext context, AuthUser? currentUser) {
    if (currentUser != null) {
      Navigator.of(context).pushNamed(PageRoutes.clients);
    }
  }
}

class EmailTextField extends StatefulWidget {
  const EmailTextField({Key? key}) : super(key: key);

  @override
  EmailTextFieldState createState() => EmailTextFieldState();
}

class EmailTextFieldState extends State<EmailTextField>{
  var _emailVisible = true;

  @override
  void initState() {
    super.initState();
    _emailVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: !_emailVisible,//This will obscure text dynamically
      decoration: InputDecoration(
       labelText: 'Mail',
       suffixIcon: IconButton(
        icon: Icon(
            _emailVisible
            ? Icons.visibility
            : Icons.visibility_off,
            color: Colors.grey.shade500,
            size: 20,
            ),
        onPressed: () {
            setState(() {
                _emailVisible = !_emailVisible;
            });
          },
        ),
      ),
      enableSuggestions: false,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => FieldValidator.validateEmail(value),
      onChanged: (value) => context.use(GetRef.loginLogic).setEmail(value),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({Key? key}) : super(key: key);

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField>{

  var _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: !_passwordVisible,//This will obscure text dynamically
      decoration: InputDecoration(
       labelText: 'Password',
       suffixIcon: IconButton(
        icon: Icon(
            _passwordVisible
            ? Icons.visibility
            : Icons.visibility_off,
            color: Colors.grey.shade500,
            size: 20,
            ),
        onPressed: () {
            setState(() {
                _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      enableSuggestions: false,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => FieldValidator.validateNotEmpty(value),
      onChanged: (value) => context.use(GetRef.loginLogic).setPassword(value),
    );
  }
}

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formStatus = context.watch(GetRef.loginStateRef.select((state) => state.submitStatus));

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: formStatus is! FormSubmitting && formStatus is! SubmissionSuccess
            ? () {
                context.use(GetRef.loginLogic).login();
              }
            : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: const Center(
            child: Text(
              'LOG IN', 
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:starter_app/constants/routes.dart';
import 'package:starter_app/services/auth/auth_exceptions.dart';
import 'package:starter_app/services/auth/auth_service.dart';
import 'package:starter_app/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;

                final userCredential = await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;

                devtools.log(userCredential.toString());

                if (user != null) {
                  devtools.log("Sending verification email");
                  await AuthService.firebase().sendEmailVerification();

                  devtools.log("Redirecting to verify email view");
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } else {
                  devtools.log("User is null after register");
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              } on WeakPasswordAuthException {
                showErrorDialog(
                  context,
                  'Password is too week.',
                );
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(
                  context,
                  'User already exists with the provided email.',
                );
              } on InvalidEmailAuthException {
                showErrorDialog(
                  context,
                  'Invalid email provided.',
                );
              } on UnknownAuthException catch (e) {
                devtools.log("Unknown FirebaseAuthException: ", error: e);
                showErrorDialog(
                  context,
                  'Something went wrong. Please try again later.',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, (route) => false);
              },
              child: const Text('Login instead'))
        ],
      ),
    );
  }
}

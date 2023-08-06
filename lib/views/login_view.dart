import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:starter_app/constants/routes.dart';
import 'package:starter_app/services/auth/auth_exceptions.dart';
import 'package:starter_app/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    if (!context.mounted) {
      return const Placeholder(
        child: Text("Loading..."),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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

                final userCredential = await AuthService.firebase().login(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;
                if (user != null && user.isEmailVerified) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeRoute, (_) => false);
                } else {
                  showErrorDialog(
                    context,
                    "User not found or email not verified.",
                  );
                }
              } on UserNotFoundOrWrongPasswordAuthException {
                devtools.log('Credentials are invalid');
                await showErrorDialog(
                  context,
                  'Invalid credentials or Email does not exist',
                );
              } on UnknownAuthException catch (e) {
                devtools.log("Unknown FirebaseAuthException: ");
                devtools.log(e.toString());
                await showErrorDialog(
                  context,
                  "Something went wrong. Please try again later.",
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Register'))
        ],
      ),
    );
  }
}

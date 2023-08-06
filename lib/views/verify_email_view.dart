import 'dart:async';

import 'package:flutter/material.dart';
import 'package:starter_app/services/auth/auth_service.dart';
import 'package:starter_app/utilities/show_custom_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  int timerSeconds = 60; // Initialize it.
  int timerMultiplier = 2;
  bool resendButtonEnabled = false;
  Timer? _timer; // Timer instance

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          resendButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify your email!")),
      body: Column(children: [
        const Center(
            child: Text("Please check your inbox and verify your email.")),
        TextButton(
          onPressed: () async {
            final user = AuthService.firebase().currentUser;
            if (resendButtonEnabled && user != null) {
              await AuthService.firebase().sendEmailVerification();
              setState(() {
                timerSeconds += 60 * timerMultiplier;
                timerMultiplier *= 2;
                resendButtonEnabled = false;
              });
              startTimer();
            } else {
              showCustomDialog(
                  context, "Please wait for some time to try again");
            }
          },
          child: const Text("Resend"),
        ),
        Text("Retry in $timerSeconds seconds")
      ]),
    );
  }
}

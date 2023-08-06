import 'package:flutter/material.dart';
import 'package:starter_app/constants/routes.dart';
import 'package:starter_app/services/auth/auth_service.dart';
import 'package:starter_app/views/login_view.dart';
import 'package:starter_app/views/home_view.dart';
import 'package:starter_app/views/register_view.dart';
import 'package:starter_app/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      homeRoute: (context) => const HomePage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user == null) {
              return const LoginView();
            } else if (!user.isEmailVerified) {
              return const VerifyEmailView();
            } else {
              return const Home();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

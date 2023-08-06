import 'package:flutter/material.dart';
import 'package:starter_app/constants/routes.dart';
import 'package:starter_app/services/auth/auth_service.dart';
import 'package:starter_app/utilities/show_log_out_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          TextButton(
              onPressed: () {
                showLogOutDialog(context).then((value) async {
                  if (value) {
                    await AuthService.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                });
              },
              child: const Text("Logout"))
        ],
      ),
      body: const Text("Home"),
    );
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/services/auth_service.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<User?>(builder: (_, notifier, __) {
          log(notifier.toString());
          return Center(
            child: Column(
              children: [
                ElevatedButton(
                    child: const Text("Sign In"),
                    onPressed: () async {
                      AuthService().googleSignIn();
                      // Navigator.pushReplacementNamed(context, "/home");
                    }),
                ElevatedButton(
                    child: const Text("Sign Out"),
                    onPressed: () async {
                      AuthService().googleSignOut();
                      // Navigator.pushReplacementNamed(context, "/home");
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}

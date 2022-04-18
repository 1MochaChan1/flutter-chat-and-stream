import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/services/auth_service.dart';
import 'package:streaming/services/database/database_service.dart';

import '../../models/custom_user.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CustomUser?>(builder: (_, cusUserNotifier, __) {
          return Center(
            child: Column(
              children: [
                ElevatedButton(
                    child: const Text("Sign In"),
                    onPressed: () async {
                      await AuthService().googleSignIn().then((user) {
                        if (user != null) {
                          context.read<DatabaseService?>()?.setUser(user);
                        }
                      });
                    }),
                ElevatedButton(
                    child: const Text("Sign Out"),
                    onPressed: () async {
                      await AuthService().googleSignOut();
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}

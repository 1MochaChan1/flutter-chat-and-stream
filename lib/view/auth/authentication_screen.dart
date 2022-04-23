import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/services/auth_service.dart';
import 'package:streaming/services/database/database_service.dart';
import 'package:streaming/view/widgets/search_field.dart';

import '../../models/custom_user.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Consumer<CustomUser?>(builder: (_, cusUserNotifier, __) {
          return SizedBox(
            height: size.height * .85,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              scrollDirection: Axis.vertical,
              reverse: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "'Be like water, my friend'\n\t\t-Bruce Lee",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Image.asset("assets/images/streamz_logo.png",
                          scale: 10.0)),
                  Text(
                    "Sign in",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    child: CustomSearchField(
                      controller: emailController,
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    child: CustomSearchField(
                      controller: passController,
                      hintText: "Password",
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                        child: const Text("Sign In"),
                        onPressed: () async {
                          final user = await AuthService().googleSignIn();
                          if (user != null) {
                            final dbProvider = context.read<DatabaseService?>();
                            await dbProvider?.setInitUser(user);
                          }
                        }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/constants.dart';
import 'package:streaming/controller/themes_provider.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/auth_service.dart';
import 'package:streaming/services/database/database_service.dart';
import 'package:streaming/themes/icons.dart';
import 'package:streaming/view/widgets/search_field.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CusTheme currentTheme = context.watch<ThemeProvider>().currThemeName;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Consumer<CustomUser?>(builder: (_, cusUserNotifier, __) {
          return SizedBox(
            height: size.height,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: size.height * .06,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: currentTheme == CusTheme.Dark
                              ? Image.asset("assets/images/streamz_logo.png",
                                  scale: 16.0)
                              : Image.asset(
                                  "assets/images/streamz_logo_light.png",
                                  scale: 16.0),
                        ),
                        Text(
                          "StreamZ",
                          style: Theme.of(context).textTheme.headline2,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .04,
                  ),
                  Flexible(
                    child: CustomSearchField(
                      leadingIcon: Icons.email_outlined,
                      controller: emailController,
                      hintText: "Email",
                    ),
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Flexible(
                    child: CustomSearchField(
                      leadingIcon: Icons.password,
                      isPassword: true,
                      controller: passController,
                      hintText: "Password",
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                        onPressed: () {}, child: const Text("Forgot Password")),
                  ),
                  Flexible(
                    child: ElevatedButton(
                        child: Text(
                          "Sign In",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: kWhite),
                        ),
                        onPressed: () {}),
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Flexible(
                      child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Flexible(
                          child: Divider(
                        endIndent: 10.0,
                      )),
                      Text(
                        "OR",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const Flexible(
                          child: Divider(
                        indent: 10.0,
                      )),
                    ],
                  )),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        final user = await AuthService().googleSignIn();
                        if (user != null) {
                          final dbProvider = context.read<DatabaseService?>();
                          await dbProvider?.setInitUser(user);
                        }
                      },
                      icon: const Icon(CustomIconPack.google),
                      label: Text(
                        "Google",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: kWhite),
                      )),
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(CustomIconPack.facebook),
                      label: Text(
                        "Facebook",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: kWhite),
                      )),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Flexible(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a user?"),
                      TextButton(onPressed: () {}, child: const Text("Sign Up"))
                    ],
                  ))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

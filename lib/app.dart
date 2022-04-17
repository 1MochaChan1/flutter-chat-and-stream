import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/custom_route_generator.dart';
import 'controller/themes_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // using a navkey to get current state of nav-stack maybe.
    GlobalKey<NavigatorState> navKey = CustomRouteGenerator.navkey;

    // starting page
    String initPage =
        FirebaseAuth.instance.currentUser == null ? "/auth" : "/home";

    // using two providers
    return Consumer2<ThemeProvider, User?>(
        builder: (_, themeNotifier, userNotifier, ___) {
      navKey.currentState?.pushNamedAndRemoveUntil(
          userNotifier == null ? "/auth" : "/home", (route) => false);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.currTheme,
        initialRoute: initPage,
        navigatorKey: navKey,
        onGenerateRoute: CustomRouteGenerator.onGenerateRoute,
      );
    });
  }
}

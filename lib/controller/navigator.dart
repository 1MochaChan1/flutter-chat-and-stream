import 'package:flutter/material.dart';
import 'package:streaming/view/auth/authentication_screen.dart';
import 'package:streaming/view/home/home_screen.dart';

class CustomNavigator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case "/auth":
        return MaterialPageRoute(builder: (_) => const AuthenticationScreen());

      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
            ),
            body: const Center(
              child: Text("404 Page not found"),
            )));
  }
}

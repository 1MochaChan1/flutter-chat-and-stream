import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/view/auth/authentication_screen.dart';
import 'package:streaming/view/contacts/users_screen.dart';
import 'package:streaming/view/home/home_screen.dart';
import 'package:streaming/view/introduction/introduction_screen.dart';

class CustomRouteGenerator {
  static final GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/intro":
        return MaterialPageRoute(
            settings: settings, builder: (_) => const IntroductionScreen());
      case "/home":
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<PageStateProvider>(
                create: (_) => PageStateProvider(), child: const HomeScreen()));

      case "/users":
        return MaterialPageRoute(
            settings: settings, builder: (_) => const UsersSreen());
      case "/auth":
        return MaterialPageRoute(
            settings: settings, builder: (_) => AuthenticationScreen());

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

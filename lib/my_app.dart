import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/models/custom_user.dart';
import 'controller/custom_route_generator.dart';
import 'controller/themes_provider.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.initPage}) : super(key: key);

  // using a navkey to get current state of nav-stack maybe.
  final GlobalKey<NavigatorState> navKey = CustomRouteGenerator.navkey;
  final String initPage;

  @override
  Widget build(BuildContext context) {
    // using two providers
    return Consumer2<ThemeProvider, CustomUser?>(
        builder: (_, themeNotifier, cusUserNotifier, ___) {
      String navPath = cusUserNotifier == null ? "/auth" : "/home";
      String currentRoute = ModalRoute.of(context)?.settings.name ?? "";
      if (currentRoute != "/intro") {
        navKey.currentState?.pushReplacementNamed(navPath);
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.currTheme,
        initialRoute: initPage,
        // initialRoute: initPage,
        navigatorKey: navKey,
        onGenerateRoute: CustomRouteGenerator.onGenerateRoute,
      );
    });
  }
}

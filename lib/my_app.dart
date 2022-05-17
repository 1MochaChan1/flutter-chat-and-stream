import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/auth_provider.dart';
import 'controller/custom_route_generator.dart';
import 'controller/themes_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initPage}) : super(key: key);

  // using a navkey to get current state of nav-stack maybe.
  static final GlobalKey<NavigatorState> _navKey = CustomRouteGenerator.navkey;
  static GlobalKey<NavigatorState> get navKey => _navKey;
  final String initPage;

  @override
  Widget build(BuildContext context) {
    // using two providers
    return Consumer2<ThemeProvider, AuthProvider>(
        builder: (_, themeNotifier, authNotifier, ___) {
      authNotifier.onAuthStateChange();
      String navPath = authNotifier.currentUser == null ? "/auth" : "/home";
      String currentRoute = ModalRoute.of(context)?.settings.name ?? "";
      if (currentRoute != "/intro") {
        _navKey.currentState
            ?.pushNamedAndRemoveUntil(navPath, (route) => false);
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.currTheme,
        initialRoute: initPage,
        navigatorKey: _navKey,
        onGenerateRoute: CustomRouteGenerator.onGenerateRoute,
      );
    });
  }
}

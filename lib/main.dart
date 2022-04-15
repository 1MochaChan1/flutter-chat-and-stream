import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/contact_provider.dart';
import 'package:streaming/controller/navigator.dart';
import 'package:streaming/controller/themes_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeProvider themeProvider = await ThemeProvider.init();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(
          create: (_) => themeProvider,
        )
      ],
      child: Consumer<ThemeProvider>(builder: (_, notifier, ___) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.currTheme,
          initialRoute: "/",
          onGenerateRoute: CustomNavigator.onGenerateRoute,
        );
      })));
}

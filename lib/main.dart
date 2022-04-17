import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/app.dart';
import 'package:streaming/controller/contact_provider.dart';
import 'package:streaming/controller/themes_provider.dart';

Future<void> main() async {
  // initializing Firebase and checking if app is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // creating themeProvider with the current theme.
  ThemeProvider themeProvider = await ThemeProvider.init();
  runApp(MultiProvider(providers: [
    // contacts provider
    ChangeNotifierProvider(create: (_) => ContactProvider()),

    // authState provider (from Firebase)
    StreamProvider<User?>(
        create: (_) => FirebaseAuth.instance.authStateChanges(),
        initialData: null),

    // theme provider
    ChangeNotifierProvider(
      create: (_) => themeProvider,
    ),
  ], child: const MyApp()));
}

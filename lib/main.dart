import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/contact_provider.dart';
import 'package:streaming/controller/user_provider.dart';
import 'package:streaming/my_app.dart';
import 'package:streaming/controller/fake_contact_provider.dart';
import 'package:streaming/controller/themes_provider.dart';
import 'package:streaming/services/auth_service.dart';
import 'package:streaming/services/database/database_service.dart';
import 'services/shared_preferences.dart';

Future<void> main() async {
  /// INITIALIZATION ///

  // initializing Firebase and checking if app is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // creating themeProvider with the current theme.
  ThemeProvider themeProvider = await ThemeProvider.init();

  // get the databaseService depending on some conditions.
  DatabaseService databaseService = await getDatabaseService();

  // get the initial page.
  String initPage = await getInitPage();

  /// RUN APP ///
  runApp(MultiProvider(
      providers: [
        // authService provider
        Provider(create: (_) => AuthService()),

        // contacts provider
        ChangeNotifierProvider(create: (_) => FakeFriendProvider()),

        // data provider
        Provider<DatabaseService?>(
          create: (_) => databaseService,
        ),

        // these just provide the users as contacts that
        // can be added by the current user.
        ChangeNotifierProvider<FriendProvider?>(
          create: (_) => FriendProvider(),
        ),

        // user provider w/ changeNotifier.
        ChangeNotifierProvider<UserProvider?>(
          create: (_) => UserProvider(),
        ),

        // authState provider (from Firebase)
        StreamProvider<User?>(
            create: (context) => context.read<AuthService>().onAuthStateChanged,
            initialData: null,
            catchError: (_, err) => null),

        // theme provider
        ChangeNotifierProvider(
          create: (_) => themeProvider,
        ),
      ],
      child: MyApp(
        initPage: initPage,
      )));
}

/// HELPERS ///
Future<String> getInitPage() async {
  late String initPage;
  await CustomPreferences.getShowIntro().then((value) {
    if (value) {
      initPage = "/intro";
      return null;
    } else {
      initPage = FirebaseAuth.instance.currentUser == null ? "/auth" : "/home";
    }
  });
  return initPage;
}

Future<DatabaseService> getDatabaseService() async {
  final spUser = await CustomPreferences.getCurrUser();

  if (spUser == null) {
    return DatabaseService();
  } else {
    return await DatabaseService.init() ?? DatabaseService();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/view/auth/authentication_screen.dart';
import 'package:streaming/view/chat/chat_room_screen.dart';
import 'package:streaming/view/friends/add_friend_screen.dart';
import 'package:streaming/view/friends/friends_list_screen.dart';
import 'package:streaming/view/friends/notifications_screen.dart';
import 'package:streaming/view/home/home_screen.dart';
import 'package:streaming/view/introduction/introduction_screen.dart';

class CustomRouteGenerator {
  static final GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case "/intro":
        return MaterialPageRoute(
            settings: settings, builder: (_) => const IntroductionScreen());
      case "/auth":
        return MaterialPageRoute(
            settings: settings, builder: (_) => AuthenticationScreen());

      case "/home":
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => MultiProvider(providers: [
                  ChangeNotifierProvider<PageStateProvider>(
                      create: (_) => PageStateProvider()),
                  // ChangeNotifierProvider(create: (_) => ChatRoomProvider())
                ], child: const HomeScreen()));

      case "/chat_room":
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings,
              builder: (_) => ChatRoomScreen(
                    chatRoom: args["chatRoom"],
                    endUser: args["endUser"],
                  ));
        }
        return errorRoute();

      case "/friends":
        return MaterialPageRoute(
            settings: settings, builder: (_) => const FriendsListScreen());

      case "/add_friend":
        return MaterialPageRoute(
            settings: settings, builder: (_) => AddFriendScreen());

      case "/notifs":
        return MaterialPageRoute(
            settings: settings, builder: (_) => const NotificationScreen());

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

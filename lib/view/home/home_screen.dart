import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/contact_provider.dart';
import 'package:streaming/controller/themes_provider.dart';

import 'package:streaming/themes/themes.dart';
import 'package:streaming/view/home/tabs/chats_tab.dart';
import 'package:streaming/view/home/tabs/movies_tab.dart';
import 'package:streaming/view/home/tabs/profile_tab.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  int bottomNavIndex = 1;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<ContactProvider>().getContacts();
    });
    super.initState();
  }

  List<Widget> tabs = [const ProfileTab(), ChatsTab(), const MovieTab()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            PopupMenuButton(
                color: Theme.of(context).backgroundColor,
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () => context
                              .read<ThemeProvider>()
                              .toggle(CusTheme.Dark),
                          child: Text(
                            "Dark",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontSize: 16.0),
                          )),
                      PopupMenuItem(
                          onTap: () => context
                              .read<ThemeProvider>()
                              .toggle(CusTheme.Light),
                          child: Text(
                            "Light",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontSize: 16.0),
                          )),
                    ])
          ],
        ),
        body: tabs[bottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          currentIndex: bottomNavIndex,
          unselectedFontSize: 0.0,
          selectedFontSize: 0.0,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(context).iconTheme.color,
          onTap: (index) async {
            setState(() {
              print(ModalRoute.of(context)?.settings.name);
              bottomNavIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.movie_outlined,
                ),
                label: ""),
          ],
        ),
      ),
    );
  }
}

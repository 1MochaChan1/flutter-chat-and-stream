import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/contact_provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/view/home/tabs/chats_tab.dart';
import 'package:streaming/view/home/tabs/movies_tab.dart';
import 'package:streaming/view/home/tabs/profile_tab.dart';
import 'package:streaming/view/widgets/custom_menu_button.dart';
import 'package:streaming/view/widgets/edit_menu_button.dart';

// ignore: must_be_immutable
// made it stateful because it needs swiping animation.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  /// DECLARATIONS ///
  ValueNotifier<int> bottomNavIndex = ValueNotifier<int>(0);

  // List<Widget> tabs = [ProfileTab(), ChatsTab(), const MovieTab()];
  final TextEditingController searchController = TextEditingController();
  final PageController _pageController = PageController();

  /// METHODS ///
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<ContactProvider>().getContacts();
    });
    super.initState();
  }

  /// WIDGET TREE ///
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            AnimatedSwitcher(
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              duration: const Duration(microseconds: 300),
              child: EditMenuButton(),
            ),
            const CustomMenuButton(),
          ],
        ),
        // body: tabs[bottomNavIndex],
        body: PageView(
          controller: _pageController,
          onPageChanged: ((index) => bottomNavIndex.value = index),
          children: [ProfileTab(), ChatsTab(), const MovieTab()],
        ),
        bottomNavigationBar: buildBottomNavBar(context),
      ),
    );
  }

  /// WIDGETS ///
  Widget buildBottomNavBar(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: bottomNavIndex,
        builder: (context, value, _) {
          return BottomNavigationBar(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            currentIndex: bottomNavIndex.value,
            unselectedFontSize: 0.0,
            selectedFontSize: 0.0,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Theme.of(context).iconTheme.color,
            onTap: (index) async {
              bottomNavIndex.value = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
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
          );
        });
  }
}

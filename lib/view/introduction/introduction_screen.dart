// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:streaming/services/shared_preferences.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with SingleTickerProviderStateMixin {
  /// VARIABLES ///
  final PageController _controller = PageController();
  late TabController _tabController;
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  /// METHODS ///
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _tabController.dispose();
    currentIndex.dispose();
  }

  /// TREE ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height * 0.92,
          child: PageView(
            // this function is to be called for viewing changes
            onPageChanged: (value) {
              currentIndex.value = _tabController.index = value;
            },
            controller: _controller,
            children: [
              // page 1
              buildPage(
                  imageAsset: "assets/images/connect.png",
                  title: "Connect With Your Friends",
                  description:
                      "Chat, call and share moments with your firends for free!"),
              // page 2
              buildPage(
                  imageAsset: "assets/images/watch_stream.png",
                  title: "Stream What You Like",
                  description: "Show off your superior 'Gaming' skills " +
                      "Or just have a movie night with your mates"),
              // Sign in
              buildPage(
                  imageAsset: "assets/images/sign_in.png",
                  title: "Proceed To Login",
                  description:
                      "You know the drill: email, password blah blah blah..."),
            ],
          ),
        ),
      ),
      bottomSheet: ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (context, counterValue, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              height: size.height * 0.08,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .22,
                          child: currentIndex.value < 2
                              ? buildProceedButton(
                                  onPressed: () {
                                    _controller.animateToPage(2,
                                        curve: Curves.ease,
                                        duration:
                                            const Duration(milliseconds: 750));
                                  },
                                  label: "Skip")
                              : Container(),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                            child: TabPageSelector(
                          controller: _tabController,
                        )),
                      ),
                      Flexible(
                          flex: 1,
                          child: buildProceedButton(
                            onPressed: () {
                              currentIndex.value < 2
                                  ? _controller.animateToPage(
                                      currentIndex.value + 1,
                                      curve: Curves.ease,
                                      duration:
                                          const Duration(milliseconds: 750))
                                  : () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, "/auth", (route) => false);
                                      CustomPreferences.setShowIntro(false);
                                    }();
                            },
                            label: "Next",
                          )),
                    ]),
              ),
            );
          }),
    );
  }

  /// WIDGETS ///

  Widget buildProceedButton(
      {required String label, required Function()? onPressed}) {
    return ElevatedButton(
      child: Text(
        label,
        style: const TextStyle(fontSize: 25.0),
      ),
      onPressed: onPressed,
    );
  }

  Widget buildPage(
      {required String imageAsset,
      required String title,
      required String description}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAsset,
            scale: 2.0,
          ),
          const SizedBox(
            height: 25.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline1),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(description,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 20.0)),
          ),
        ],
      )),
    );
  }
}

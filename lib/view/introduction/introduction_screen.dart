import 'package:flutter/material.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          // page 1
          Container(),
          // page 2
          Container(),
          // Sign in
          Container()
        ],
      ),
    );
  }
}

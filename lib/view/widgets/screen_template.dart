import 'package:flutter/material.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget child;
  const ScreenTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: child,
    );
  }
}

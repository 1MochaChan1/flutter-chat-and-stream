import 'package:flutter/material.dart';

class MovieTab extends StatelessWidget {
  const MovieTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Center(
          child: Text(
        "Coming Soon",
        style: Theme.of(context).textTheme.bodyText2,
      )),
    );
  }
}

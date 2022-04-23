import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? leadingIcon;
  const CustomSearchField(
      {Key? key, this.controller, this.hintText = "", this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).bottomAppBarColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          prefixIcon: Icon(
            leadingIcon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}

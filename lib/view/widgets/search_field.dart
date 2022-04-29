// ignore_for_file: prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? leadingIcon;
  final Widget? trailingIcon;
  final TextInputType? keyboardType;
  final bool isPassword;
  ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  CustomSearchField({
    Key? key,
    this.controller,
    this.hintText = "",
    this.leadingIcon,
    this.trailingIcon,
    this.isPassword = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isPasswordVisible,
        builder: (context, value, _) {
          return TextField(
            controller: controller,
            style: Theme.of(context).textTheme.headline6,
            keyboardType: keyboardType,
            obscureText: isPassword && !_isPasswordVisible.value,
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).bottomAppBarColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                prefixIcon: Icon(
                  leadingIcon,
                  color: Theme.of(context).hintColor,
                ),
                suffixIcon: isPassword
                    ? InkWell(
                        splashColor: Colors.transparent,
                        child: Icon(
                          Icons.visibility_outlined,
                          color: _isPasswordVisible.value
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).hintColor,
                        ),
                        onTap: () => showPassword(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: trailingIcon),
                hintText: hintText,
                hintStyle: const TextStyle(fontWeight: FontWeight.w500)),
          );
        });
  }

  /// METHODS ///
  showPassword() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }
}

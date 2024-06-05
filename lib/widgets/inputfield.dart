import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final bool isPassword;
  final TextEditingController? controller;
  final String hintText;
  final TextInputType inputType;
  final Color fillColor;
  const TextInput(
      {super.key,
      this.isPassword = false,
      required this.controller,
      required this.hintText,
      required this.inputType,
      required this.fillColor, 
      });

  @override
  Widget build(BuildContext context) {
    final border =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: fillColor,
        hintText: hintText,
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        filled: true,
        contentPadding: const EdgeInsets.all(8)),
      keyboardType: inputType,
      obscureText: isPassword,
    );
  }
}
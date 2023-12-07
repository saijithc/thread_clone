import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType inputKeyboardType;
  final String hintText;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.inputKeyboardType,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: inputKeyboardType,
      obscureText: isPassword,
    );
  }
}

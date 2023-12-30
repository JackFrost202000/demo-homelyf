// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String? semanticsLabel;
  final int maxLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? customValidator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.semanticsLabel,
    this.maxLines = 2,
    this.obscureText = false,
    this.suffixIcon,
    this.customValidator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 173, 173, 173),
          fontWeight: FontWeight.w300,
        ),
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        filled: true,
        fillColor: const Color.fromARGB(207, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 131, 131, 131),
          ),
        ),
        suffixIcon: widget.suffixIcon,
        semanticCounterText: widget.semanticsLabel,
        errorMaxLines: 2,
      ),
      validator: widget.customValidator ??
          (val) {
            if (val == null || val.isEmpty) {
              return 'Please Enter Email Address';
            }
            return null;
          },
    );
  }
}

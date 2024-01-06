// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:homelyf_services/constants/global_variables.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final double? height;
  final double? elevation;
  final bool visible;

  const CustomButton({
    Key? key,
    required this.text,
    this.backgroundColor,
    required this.onTap,
    this.height,
    this.elevation,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = backgroundColor ?? GlobalVariables.secondaryColor;
    return Visibility(
      visible: visible,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, height ?? 50),
          backgroundColor: buttonColor,
          elevation: elevation ?? 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

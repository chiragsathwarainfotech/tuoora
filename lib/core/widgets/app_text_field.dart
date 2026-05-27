import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/widgets/input_styles.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    // Routes everything through the shared institute input tokens so this
    // matches AppInputField / AppSearchField / InstituteTextField. White
    // fill is kept (the original styling) by passing `fillColor`.
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: InputStyles.textStyle(),
      decoration: InputStyles.filled(
        hintText: hintText,
        fillColor: AppColors.white,
      ),
    );
  }
}

// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  // (核心) 1.
  //    定义你*需要*的所有参数
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {

    // (核心) 2.
    //    在这里*一次性*定义你的"脚手架"样式
    //    (我从你的 LoginPage 复制了"白色"样式)
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white), // (核心) 统一样式
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white70), // (核心) 统一样式
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.white)
            : null,

        // (核心) 统一边框
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // (你还可以在这里统一定义 'errorBorder')
      ),
      validator: validator,
    );
  }
}
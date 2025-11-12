// lib/core/utils/validators.dart

import 'package:get/get.dart';

class Validators {
  // (封装)
  // 1.
  //    “不能为空”的规则
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'input_cant_be_empty'.tr;
    }
    return null;
  }

  // (封装)
  // 2.
  //    “密码”的规则
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_cant_be_empty'.tr;
    }
    if (value.length < 6) {
      return 'password_length_error1'.tr;
    }
    if (value.length > 10) {
      return 'password_length_error2'.tr;
    }
    return null;
  }

  // (封装)
  // 3.
  //    “邮箱”的规则
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'input_cant_be_empty'.tr;
    }
    // (使用 GetX 自带的正则)
    if (!GetUtils.isEmail(value)) {
      return 'email_format_error'.tr; // (例如: "邮箱格式不正确")
    }
    return null;
  }
}
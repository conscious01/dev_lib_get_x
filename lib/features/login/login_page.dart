import 'package:dev_lib_getx/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'login_logic.dart';

class LoginPage extends GetView<LoginLogic> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // (关键) 我们用 Stack 来实现“背景图在下, 表单在上”
      body: Stack(
        fit: StackFit.expand, // 让 Stack 填满全屏
        children: [
          // --- 1. 背景层 ---
          _buildBackgroundImage(),

          // --- 2. 蒙版层 (可选, 但推荐,
          //         让白色文字在复杂背景上更清晰)
          Container(color: Colors.black.withOpacity(0.3)),

          // --- 3. 表单层 ---
          Center(
            // (关键) Obx 负责在 "加载中" 和 "表单" 之间切换
            child: _buildLoginForm(context),
          ),
        ],
      ),
    );
  }

  // --- UI 1: 背景图 ---
  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          // 你的图片路径
          image: Assets.images.loginBg.image().image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // --- UI 2: 登录表单 ---
  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        // 防止键盘弹起时溢出
        padding: EdgeInsets.symmetric(horizontal: 32.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'login_welcome'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40.h),

            // --- 用户名输入 ---
            TextFormField(
              controller: controller.userNameController,
              decoration: InputDecoration(
                labelText: 'input_username'.tr,
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.people, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'input_cant_be_empty'.tr; // <-- 你的规则 1
                }
                return null; // (null = 验证通过)
              },
            ),
            SizedBox(height: 20.h),

            // --- 密码输入 ---
            TextFormField(
              controller: controller.passwordController,
              obscureText: true,
              // 隐藏密码
              decoration: InputDecoration(
                labelText: 'login_password'.tr,
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password_cant_be_empty'.tr;
                }
                if (value.length < 6) {
                  return 'password_length_error1'.tr; // <-- 你的规则 2
                }
                if (value.length > 10) {
                  return 'password_length_error2'.tr; // <-- 你的规则 3
                }
                return null; // (null = 验证通过)
              },
            ),
            SizedBox(height: 10.h),

            // --- 错误信息显示 ---
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red.shade300, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                );
              } else {
                return SizedBox(height: 0);
              }
            }),
            SizedBox(height: 20.h),

            // --- 登录按钮 (带加载状态) ---
            ElevatedButton(
              // (关键) 如果在加载中, onPressed 为 null (禁用按钮)
              onPressed: controller.login,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text('login_button'.tr, style: TextStyle(fontSize: 18.sp)),
            ),
          ],
        ),
      ),
    );
  }
}

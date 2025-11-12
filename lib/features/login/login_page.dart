import 'package:dev_lib_getx/core/widgets/base_page.dart';
import 'package:dev_lib_getx/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/app_text_field.dart';
import 'login_logic.dart';

class LoginPage extends GetView<LoginLogic> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Stack(
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
            AppTextField(
              controller: controller.userNameController,
              labelText: 'input_username'.tr,
              prefixIcon: Icons.people,
                validator: Validators.required,
            ),
            SizedBox(height: 20.h),

            // --- 密码输入 ---
            AppTextField(
              controller: controller.passwordController,
              labelText: 'login_password'.tr,
              prefixIcon: Icons.lock,
              obscureText: true,
              validator: Validators.password,
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
            Obx(() {
              // (B) 获取两个状态
              final bool isFormValid = controller.isFormValid.value;

              return ElevatedButton(
                onPressed: !isFormValid ? null : controller.login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  'login_button'.tr,
                  style: TextStyle(fontSize: 18.sp),
                ),
              );
            }),

            SizedBox(height: 20.h),

            Obx(() {
              // (B) 获取两个状态
              final bool isFormValid = controller.isFormValid.value;
              return ElevatedButton(
                onPressed: !isFormValid ? null : controller.loginFull,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  'login_button_with_full_res'.tr,
                  style: TextStyle(fontSize: 18.sp),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

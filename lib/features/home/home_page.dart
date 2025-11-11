import 'package:dev_lib_getx/features/home/home_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';

class HomePage extends GetView<HomeLogic> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.isDarkMode;
    return Scaffold(
      appBar: AppBar(title: Text("first_page".tr)),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: Text(
                'drawer_menu'.tr,
                style: TextStyle(color: Colors.white, fontSize: 24.sp),
              ),
            ),

            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('profile'.tr), // (推荐: 'profile_title'.tr)
              onTap: () {
                // (A) (不变) 先关闭抽屉
                Get.back();

                // (B) (核心!)
                //    调用 ShellLogic 来切换到第 4 个 Tab (索引 3)
                controller.goToProfile();
              },
            ),

            // (核心) 5.
            //    (新增!) 切换语言
            ListTile(
              leading: Icon(Icons.language),
              title: Text('profile_change_language'.tr), // "切换语言"
              // (核心) 6.
              //    (你的需求) "显示出当前使用的什么语言"
              //    我们在这里直接读取 GetX 的全局 locale
              subtitle: Text(
                Get.locale?.languageCode == 'zh'
                    ? "当前: 中文"
                    : "Current: English",
              ),

              onTap: () {
                // (A) (可选)
                //     我们*不*关闭抽屉 (Get.back()),
                //     而是直接弹出语言对话框
                _showLanguageDialog(context);
              },
            ),
            ListTile(
              // (核心) 4.
              //    根据当前状态, 显示不同图标
              leading: Icon(
                isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),

              title: Text(
                isDarkMode
                    ? "switch_to_light_theme".tr
                    : "switch_to_dark_theme".tr,
              ),

              onTap: () {
                final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
                Get.changeThemeMode(newMode);
                Get.find<StorageService>().saveThemeMode(newMode);
                Get.back();
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.sendEvent);
              },
              child: Text(
                'jump_2_send_event_page'.tr,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),

            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.listPage);
              },
              child: Text('list_page'.tr, style: TextStyle(fontSize: 18.sp)),
            ),

            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.commonWidgetOrStyle);
              },
              child: Text('common_component_button_style'.tr, style: TextStyle(fontSize: 18.sp)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('profile_change_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min, // 让 Column 包裹内容
          children: [
            // (A) 切换到中文
            ListTile(
              title: Text("中文 (简体)"),
              onTap: () {
                // (核心)
                //    调用 GetX 的 i18n API
                //    GetX 会自动重绘所有 .tr 文本
                Get.updateLocale(const Locale('zh', 'CN'));
                Get.back(); // 关闭对话框
              },
            ),

            // (B) 切换到英文
            ListTile(
              title: Text("English (US)"),
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                Get.back(); // 关闭对话框
              },
            ),
          ],
        ),
      ),
    );
  }
}

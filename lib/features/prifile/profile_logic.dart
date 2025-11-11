import 'package:dev_lib_getx/core/models/login_result_entity.dart';
import 'package:flutter/material.dart'; // (核心) 1. 导入 (用于 AlertDialog)
import 'package:get/get.dart';
import '../../core/services/app_data_service.dart'; // 导入
import '../../core/services/logger_service.dart'; // 导入
import '../../routes/app_routes.dart'; // 导入

// (不变)
class ProfileLogic extends GetxController {

  // (核心) 2.
  //    使用"服务定位" (Service Locator)
  //    获取你全局的 AppDataService
  final AppDataService appData = Get.find<AppDataService>();

  // (核心) 3.
  //    创建一个"计算属性" (getter)
  //    这样 UI 就可以简单地 'controller.user.value'
  //    来 *响应式* 地获取用户数据
  Rxn<LoginResultEntity> get user => appData.currentUser;


  // --- (核心) 你的需求 ---

  /// (Action 1)
  /// Page(视图) 将调用这个方法来"显示"对话框
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        // (推荐)
        //    标题和内容也应该使用 i18n
        title: Text('profile_logout'.tr),
        content: Text('profile_logout_confirm_msg'.tr), // (例如: "您确定要退出吗?")

        actions: [
          // (A) 取消按钮
          TextButton(
            child: Text('cancel'.tr), // (例如: "取消")
            onPressed: () {
              Get.back(); // 只需关闭对话框
            },
          ),

          // (B) 确认按钮
          TextButton(
            child: Text('confirm'.tr), // (例如: "确认")
            onPressed: () {
              // (关键!)
              // 1. 先关闭对话框
              Get.back();
              // 2. 再调用*真正*的登出逻辑
              _executeLogout();
            },
          ),
        ],
      ),
    );
  }

  /// (Action 2)
  /// (私有)
  /// 真正执行"删除数据"和"跳转"
  Future<void> _executeLogout() async {
    try {
      logger.i("用户正在退出登录...");

      // 1. (核心) "删除数据"
      //    (调用 AppDataService,
      //     它会清除内存和磁盘)
      await appData.signOut();

      // 2. (核心) "跳转到登录页面"
      //    (使用 offAllNamed 清除所有页面栈)
      Get.offAllNamed(AppRoutes.authLogin);

    } catch (e, s) {
      logger.e("退出登录失败", error: e, stackTrace: s);
      // (可选)
      //    给出一个友好的提示
      Get.snackbar(
        "操作失败",
        "退出登录时发生错误, 请重试",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
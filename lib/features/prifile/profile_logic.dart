import 'package:flutter/material.dart'; // (核心) 1. 导入 (用于 AlertDialog)
import 'package:get/get.dart';
import '../../core/services/app_data_service.dart'; // 导入
import '../../core/services/dialog_service.dart';
import '../../core/services/logger_service.dart'; // 导入
import '../../models/login_result_entity.dart';
import '../../routes/app_routes.dart'; // 导入

// (不变)
class ProfileLogic extends GetxController {

  // (核心) 2.
  //    使用"服务定位" (Service Locator)
  //    获取你全局的 AppDataService
  final AppDataService appData = Get.find<AppDataService>();
  final DialogService _dialog = Get.find<DialogService>();

  // (核心) 3.
  //    创建一个"计算属性" (getter)
  //    这样 UI 就可以简单地 'controller.user.value'
  //    来 *响应式* 地获取用户数据
  Rxn<LoginResultEntity> get user => appData.currentUser;


  // --- (核心) 你的需求 ---

  /// (Action 1)
  /// Page(视图) 将调用这个方法来"显示"对话框
  Future<void> showLogoutDialog() async {
    final bool didConfirm = await _dialog.showConfirmDialog(
      title: 'profile_logout'.tr,
      content: 'profile_logout_confirm_msg'.tr,
    );

    if (didConfirm) { // (核心!)
      _executeLogout();
    }
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
      _dialog.showErrorToast("退出登录时发生错误, 请重试");

    }
  }
}
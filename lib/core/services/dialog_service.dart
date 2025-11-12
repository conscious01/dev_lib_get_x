// lib/core/services/dialog_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../widgets/loading_dialog.dart'; // 导入你的 Loading UI

class DialogService extends GetxService {

  // --- (A) Loading ---

  void showLoading() {
    // (封装)
    Get.dialog(
      const LoadingDialog(),
      barrierDismissible: false,
    );
  }

  void hideLoading() {
    // (封装)
    // 确保 dialog 是打开的, 然后才关闭
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // --- (B) Toast / Snackbar ---

  void showSuccessToast(String message) {
    // (封装)
    Get.snackbar(
      "操作成功",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void showErrorToast(String message, {String title = "操作失败"}) {
    // (封装)
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // --- (C) 确认对话框 ---

  /// (封装)
  /// (这是你 'ProfileLogic'
  ///  的 'showLogoutDialog' 的*通用*版本)
  Future<bool> showConfirmDialog({
    String title = '请确认',
    String content = '您确定要执行此操作吗？',
    String confirmText = '确认',
    String cancelText = '取消',
  }) async {

    // (核心)
    //    Get.dialog *可以* 返回一个值
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title.tr), // (它甚至可以支持 i18n)
        content: Text(content.tr),
        actions: [
          TextButton(
            child: Text(cancelText.tr),
            onPressed: () => Get.back(result: false), // (返回 false)
          ),
          TextButton(
            child: Text(confirmText.tr),
            onPressed: () => Get.back(result: true), // (返回 true)
          ),
        ],
      ),
    );

    // (核心)
    //    如果用户点击外部关闭,
    //    result 会是 null, 我们也视为 'false'
    return result ?? false;
  }
}
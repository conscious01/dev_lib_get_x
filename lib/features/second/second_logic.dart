import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/login_result_entity.dart';

class SecondLogic extends GetxController {
  final AppDataService appData = Get.find<AppDataService>();

  Rxn<LoginResultEntity> get user => appData.currentUser;
  late TextEditingController userNameController;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    userNameController = TextEditingController(
      text: user.value?.loginResultEntityOperator.name,
    );
  }

  @override
  void onClose() {
    userNameController.dispose();
    super.onClose();
  }

  Future<void> updateUsername() async {
    // A. 获取新名字
    final String newName = userNameController.text.trim();

    // B. (可选) 校验
    if (newName.isEmpty) {
      Get.snackbar(
        "更新失败",
        "用户名不能为空",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // C. 获取当前用户
    final LoginResultEntity? oldUser = appData.currentUser.value;
    if (oldUser == null) {
      Get.snackbar("错误", "用户未登录");
      return;
    }

    final newOperator = oldUser.loginResultEntityOperator.copyWith(
      name: newName,
    );
    final LoginResultEntity newUser = oldUser.copyWith(
      loginResultEntityOperator: newOperator,
    );

    await appData.saveLoginEntity(newUser);

    Get.snackbar(
      "更新成功",
      "用户名已更新为: $newName",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

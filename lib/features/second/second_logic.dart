import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/dialog_service.dart';
import '../../models/login_result_entity.dart';

class SecondLogic extends GetxController {
  final AppDataService appData = Get.find<AppDataService>();
  final DialogService _dialog = Get.find<DialogService>();
  Rxn<LoginResultEntity> get user => appData.currentUser;
  late TextEditingController userNameController;
  late TextEditingController eventController;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    eventController = TextEditingController();

    userNameController = TextEditingController(
      text: user.value?.loginResultEntityOperator.name,
    );
  }

  @override
  void onClose() {
    userNameController.dispose();
    eventController.dispose();

    super.onClose();
  }

  Future<void> updateUsername() async {
    // A. 获取新名字
    final String newName = userNameController.text.trim();

    // B. (可选) 校验
    if (newName.isEmpty) {
      _dialog.showErrorToast("用户名不能为空");
      return;
    }

    // C. 获取当前用户
    final LoginResultEntity? oldUser = appData.currentUser.value;
    if (oldUser == null) {
      _dialog.showErrorToast("用户未登录");
      return;
    }

    final newOperator = oldUser.loginResultEntityOperator.copyWith(
      name: newName,
    );
    final LoginResultEntity newUser = oldUser.copyWith(
      loginResultEntityOperator: newOperator,
    );

    await appData.saveLoginEntity(newUser);
    _dialog.showSuccessToast("用户名已更新为: $newName");
  }

  void sendEvent() {
    final String eventData = eventController.text.trim();
    if (eventData.isEmpty) {
      _dialog.showErrorToast("输入不能为空!");
      return;
    }
    appData.eventData.value = eventData;
  }
}

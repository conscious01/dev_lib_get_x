import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/login_result_entity.dart';

class SendEventLogic extends GetxController {
  final AppDataService appData = Get.find<AppDataService>();

  Rxn<LoginResultEntity> get user => appData.currentUser;
  late TextEditingController eventController;

  @override
  void onInit() {
    super.onInit();
    eventController = TextEditingController();
  }

  @override
  void onClose() {
    eventController.dispose();
    super.onClose();
  }

  void sendEvent() {
    final String eventData = eventController.text.trim();
    if (eventData.isEmpty) {
      Get.snackbar(
        "操作失败",
        "输入不能为空!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    appData.eventData.value = eventData;
  }
}

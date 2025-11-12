import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/dialog_service.dart';
import '../../models/login_result_entity.dart';

class SendEventLogic extends GetxController {
  final AppDataService appData = Get.find<AppDataService>();
  final DialogService _dialog = Get.find<DialogService>();

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
      _dialog.showErrorToast("输入不能为空!");

      return;
    }
    appData.eventData.value = eventData;
  }
}

import 'dart:async';

import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class SplashLogic extends GetxController {
  final AppDataService appData = Get.find<AppDataService>();

  var countDown = 3.obs;
  late final Timer _timer;

  @override
  void onReady() {
    super.onReady();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countDown.value > 1) {
        countDown.value--;
      } else {
        _timer.cancel();
        navigateToNextPage();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void onClose() {
    _timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.onClose();
  }

  void navigateToNextPage() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    bool isLoggedIn = appData.isLoggedIn;
    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.shell);
    } else {
      Get.offAllNamed(AppRoutes.authLogin);
    }
  }
}

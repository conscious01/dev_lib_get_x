import 'dart:async';

import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class ThirdLogic extends GetxController {
  final AppDataService appData = Get.find<AppDataService>();

  Rxn<dynamic> get eventData => appData.eventData;
}

import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:dev_lib_getx/features/send_event/send_event_logic.dart';
import 'package:dev_lib_getx/features/splash/splash_logic.dart';
import 'package:get/get.dart';

class SendEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SendEventLogic());
  }
}

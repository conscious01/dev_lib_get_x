import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:dev_lib_getx/features/splash/splash_logic.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashLogic());
  }
}

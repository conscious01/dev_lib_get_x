import 'package:dev_lib_getx/core/repository/app_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../core/services/storage_service.dart';
import 'login_logic.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {

    //    (关键) 把 Repository 实例传递给 Controller
    Get.lazyPut<LoginLogic>(
          () => LoginLogic(
        // (核心) 从 GetX 查找那个全局唯一的 AppRepository
        appRepo: Get.find<AppRepository>(),
        storage: Get.find<StorageService>(),
      ),
    );
  }
}
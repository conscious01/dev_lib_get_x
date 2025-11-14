import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:dev_lib_getx/features/shell/shell_logic.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  final ShellLogic shellLogic = Get.find<ShellLogic>();

  final AppDataService appData = Get.find<AppDataService>();

  Rxn<dynamic> get eventData => appData.eventData;

  @override
  void onInit() {
    super.onInit();
    ever(eventData, (dynamic newEventData) {
      // 4. 当 'eventData' 的值发生变化时, 立即执行此回调
      if (newEventData != null) {
        // 5. (核心) 在这里执行您的 "动作"
        Get.snackbar(
          "SecondLogic 收到了一个新事件!",
          newEventData.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  void goToProfile() {
    shellLogic.changeTabIndex(3);
  }
}

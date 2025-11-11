import 'package:dev_lib_getx/features/shell/shell_logic.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  final ShellLogic shellLogic = Get.find<ShellLogic>();

  void goToProfile() {
    shellLogic.changeTabIndex(3) ;
  }
}

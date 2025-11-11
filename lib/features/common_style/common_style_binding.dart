import 'package:get/get.dart';

import 'common_style_logic.dart';

class CommonStyleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommonStyleLogic());
  }
}

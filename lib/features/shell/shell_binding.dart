import 'package:dev_lib_getx/features/prifile/profile_logic.dart';
import 'package:dev_lib_getx/features/second/second_logic.dart';
import 'package:dev_lib_getx/features/third/third_logic.dart';
import 'package:get/get.dart';

import '../home/home_logic.dart';
import 'shell_logic.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShellLogic>(() => ShellLogic());

    Get.lazyPut<HomeLogic>(() => HomeLogic());

    Get.lazyPut<SecondLogic>(() => SecondLogic());

    Get.lazyPut<ThirdLogic>(() => ThirdLogic());

    Get.lazyPut<ProfileLogic>(() => ProfileLogic());
  }
}

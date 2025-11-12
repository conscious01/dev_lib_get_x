import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:dev_lib_getx/features/post/post_list_logic.dart';
import 'package:dev_lib_getx/features/prifile/profile_logic.dart';
import 'package:dev_lib_getx/features/splash/splash_logic.dart';
import 'package:get/get.dart';

class PostListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostListLogic());
  }
}

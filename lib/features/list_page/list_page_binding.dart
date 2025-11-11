import 'package:get/get.dart';

import 'list_page_logic.dart';

class ListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListPageLogic());
  }
}
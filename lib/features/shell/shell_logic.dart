import 'package:get/get.dart';

class ShellLogic extends GetxController {

  // (核心)
  // 1.
  //    '0' 代表第一个 Tab (首页)
  //    .obs 使它成为一个"响应式"变量
  var selectedIndex = 0.obs;

  // (核心)
  // 2.
  //    这是 BottomNavigationBar 将调用的方法
  //    它会更新 'selectedIndex',
  //    任何 Obx() 监听了它的地方都会自动刷新
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
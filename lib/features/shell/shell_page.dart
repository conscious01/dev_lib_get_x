import 'package:dev_lib_getx/features/prifile/profile_page.dart';
import 'package:dev_lib_getx/features/second/second_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_page.dart';
import '../third/third_page.dart';
import 'shell_logic.dart';

class ShellPage extends GetView<ShellLogic> {
  final List<Widget> _pages = [
    HomePage(),
    SecondPage(),
    ThirdPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        ),
      ),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,

          onTap: controller.changeTabIndex,

          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'first_page'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: "second_page".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.network_wifi_outlined),
              activeIcon: Icon(Icons.network_wifi),
              label: "third_page".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "profile_page".tr,
            ),
          ],
        ),
      ),
    );
  }
}

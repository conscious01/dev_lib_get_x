import 'package:dev_lib_getx/features/prifile/profile_page.dart';
import 'package:dev_lib_getx/features/second/second_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../home/home_page.dart';
import '../third/third_page.dart';
import 'shell_logic.dart';

class ShellPage extends GetView<ShellLogic> {


  final List<Widget> _pages = [
    HomePage(),       // <-- 索引 0
    SecondPage(),   // <-- 索引 1
    ThirdPage(),   // <-- 索引 2
    ProfilePage(),    // <-- 索引 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // (核心) 3.
      //    我们使用 Obx 来监听 'selectedIndex'
      body: Obx(() => IndexedStack(
        // (核心)
        //    IndexedStack 会根据 index,
        //    只 *显示* 对应的页面,
        //    但 *保持* 4 个页面都在内存中
        index: controller.selectedIndex.value,
        children: _pages,
      )),

      // (核心) 4.
      //    我们 *再次* 使用 Obx
      //    (是的, 你可以有多个 Obx)
      //    来监听 'selectedIndex'
      bottomNavigationBar: Obx(() => BottomNavigationBar(

        // (核心) 5. (你的需求: 选中状态)
        //    告诉 BottomNavBar 当前选中的是哪个
        currentIndex: controller.selectedIndex.value,

        // (核心) 6. (你的需求: 切换)
        //    当用户点击时, 调用 Logic 的方法
        onTap: controller.changeTabIndex,

        // (推荐)
        //    这个设置确保 4 个 Tab 都会显示,
        //    而不是“平移”
        type: BottomNavigationBarType.fixed,

        // (推荐)
        //    设置选中和未选中的颜色
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,

        // (核心) 7.
        //    你的 4 个 Tab 按钮
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // (可选: 选中时显示不同图标)
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: "列表",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: "消息",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "我的",
          ),
        ],

      )),
    );
  }
}
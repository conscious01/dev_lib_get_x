import 'package:dev_lib_getx/features/home/home_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // (推荐) 导入

class HomePage extends GetView<HomeLogic> {
  const HomePage({super.key}); // (推荐) 添加 super.key

  @override
  Widget build(BuildContext context) {

    // (核心) 1.
    //    你必须返回一个 Scaffold 才能拥有 Drawer
    return Scaffold(

      // (核心) 2.
      //    你 *必须* 添加一个 AppBar
      //    Flutter 会自动检测到 'drawer' 属性,
      //    并自动在左上角添加“汉堡”菜单图标 ☰
      appBar: AppBar(
        title: Text("首页"), // (你可以用 'home_title'.tr)
        backgroundColor: Colors.blue, // (可选: 自定义颜色)
      ),

      // (核心) 3. (你的需求)
      //    添加 "drawer" 属性
      drawer: Drawer(
        // (推荐)
        //    在 Drawer 内部使用 ListView,
        //    以便内容可滚动
        child: ListView(

          // (重要!)
          //    移除 ListView 顶部的默认空白
          padding: EdgeInsets.zero,

          children: [

            // (A) (推荐)
            //     一个漂亮的抽屉头部
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: Text(
                '抽屉菜单',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp, // (使用 .sp 适配)
                ),
              ),
            ),

            // (B) (推荐)
            //     菜单项
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('个人资料'),
              onTap: () {
                // (核心)
                // 1. (必须!) 先关闭抽屉
                Get.back();

                // 2. (可选) 再导航到新页面
                //    (注意: 这会导航到 Shell *之上*)
                // Get.toNamed(AppRoutes.PROFILE_DETAIL);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
              onTap: () {
                Get.back();
              },
            ),

          ],
        ),
      ),

      // (核心) 4.
      //    把你 *原来* 的 UI (Center)
      //    放到 'body' 属性里
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
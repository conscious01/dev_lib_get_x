import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // 私有构造
  AppTheme._();

  // (核心)
  // 1. 你的“亮色”主题
  // (当 Get.isDarkMode == false 时自动使用)
  static final ThemeData lightTheme = ThemeData(
    // (A) 核心: 告诉 Flutter 这是个亮色主题
    brightness: Brightness.light,

    // (B) (你的需求)
    //     在这里定义“亮色”时, 你想看到的颜色
    //     (我们让 AppBar 保持蓝色, 但背景设为浅灰)
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100], // (亮色背景)

    // (C) (推荐)
    //     统一 AppBar 样式
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue, // 亮色时的 AppBar 颜色
      foregroundColor: Colors.white, // 亮色时的 AppBar 标题颜色
    ),

    // (D) (推荐)
    //     统一卡片 Card 样式
    cardColor: Colors.white, // 亮色时的卡片背景
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, // (亮色)
      selectedItemColor: Colors.blue, // (亮色) 选中的
      unselectedItemColor: Colors.grey[600], // (亮色) 未选中的
    ),
  );


  // (核心)
  // 2. 你的“暗色”主题
  // (当 Get.isDarkMode == true 时自动使用)
  static final ThemeData darkTheme = ThemeData(
    // (A) 核心: 告诉 Flutter 这是个暗色主题
    brightness: Brightness.dark,

    // (B) (你的需求)
    //     在这里定义“暗色”时, 你想看到的颜色
    primarySwatch: Colors.blue, // (我们让"强调色"保持蓝色)
    scaffoldBackgroundColor: Colors.grey[900], // (暗色背景)

    // (C) (推荐)
    //     统一 AppBar 样式
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850], // 暗色时的 AppBar 颜色
      foregroundColor: Colors.white, // 暗色时的 AppBar 标题颜色
    ),

    // (D) (推荐)
    //     统一卡片 Card 样式
    cardColor: Colors.grey[800], // 暗色时的卡片背景

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850], // (暗色)
      selectedItemColor: Colors.blue[300], // (暗色) 选中的 (一个更柔和的蓝)
      unselectedItemColor: Colors.grey[400], // (暗色) 未选中的 (一个更亮的灰)
    ),
  );
}
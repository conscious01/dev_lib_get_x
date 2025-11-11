import 'package:flutter/material.dart';

/// (核心)
/// 这是一个“基础” Widget, 你的“脚手架”中的所有页面都应该使用它。
///
/// 它自动提供了"点击空白处隐藏键盘"的功能。
/// 它只是一个 StatelessWidget, 负责封装逻辑。
class BasePage extends StatelessWidget {

  // (核心)
  // 你的 "真正" 页面内容, 会通过 child 传进来
  final Widget child;

  // (可选)
  // 你甚至可以把 AppBar 和 FAB 也作为参数传进来
  // 这样你的脚手架就更统一了
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const BasePage({
    Key? key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // (核心)
    // 1. 我们用 GestureDetector 包裹 *整个* Scaffold
    return GestureDetector(

      // (核心)
      // 2. 这是"隐藏键盘"的动作
      onTap: () {
        // (推荐)
        // 使用 FocusManager.instance.primaryFocus
        // 比 FocusScope.of(context) 更健壮
        FocusManager.instance.primaryFocus?.unfocus();
      },

      // (核心)
      // 3. (关键!)
      //    默认情况下, GestureDetector 只会响应"有内容"的区域
      //    (比如一个按钮), 它会*忽略*空白的 Padding 或 Container。
      //
      //    设置 'HitTestBehavior.opaque' 会告诉它:
      //    "把我也当作一个不透明的实体, 即使是空白区域也要响应点击！"
      behavior: HitTestBehavior.opaque,

      // 4. 你的“真实”页面 UI
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        body: child, // <-- 你的 Page (例如 Login Page) 会被放在这里
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
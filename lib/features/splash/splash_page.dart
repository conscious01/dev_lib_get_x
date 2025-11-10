import 'package:dev_lib_getx/features/splash/splash_logic.dart';
import 'package:dev_lib_getx/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. (重要) 导入服务
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashLogic> {
  @override
  Widget build(BuildContext context) {
    // 2. (核心) 设置为全屏模式
    // immersiveSticky 是一种“粘性”沉浸式，用户很难滑出系统栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      // 3. (核心)
      //    Container 作为 body, 默认会填满 Scaffold
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // 4. (核心) 使用 AssetImage 加载你的本地图片
                //    确保这个路径和你的 pubspec.yaml 里的一致
                image: Assets.images.splash.image().image,

                // 5. (推荐) 让图片填满整个屏幕, 可能会裁剪
                fit: BoxFit.cover,
              ),
            ),
            // (可选) 你可以在背景图上再加一个 Logo 或加载动画
            child: Center(
              // child: CircularProgressIndicator(color: Colors.white),
            ),
          ),

          _buildCountdownUI(),
        ],
      ),
    );
  }

  Widget _buildCountdownUI() {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Obx(
          () => GestureDetector(
            onTap: () => {controller.navigateToNextPage()},
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // 半透明背景
                borderRadius: BorderRadius.circular(20.r), // 圆角
              ),
              child: Text(
                "splash_skip".trParams({
                  "count": (controller.countDown.value ).toString(),
                }),
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

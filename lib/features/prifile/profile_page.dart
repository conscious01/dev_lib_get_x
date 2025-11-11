import 'package:dev_lib_getx/core/services/logger_service.dart'; // (核心) 导入 log
import 'package:dev_lib_getx/features/prifile/profile_logic.dart';
import 'package:dev_lib_getx/gen/assets.gen.dart'; // (核心) 导入 (用于占位图)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // (核心) 导入
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends GetView<ProfileLogic> {
  const ProfilePage({super.key}); // (推荐) 添加 const 和 key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // (推荐)
      //    我们让这个 AppBar
      //    也支持国际化 (i18n)
      appBar: AppBar(title: Text('profile_title'.tr)),

      // (核心)
      //    我们使用 Column 来垂直排列
      body: Center(
        // (可选) 让所有内容在中间
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            // (核心)
            //    让 Column 包裹内容, 并居中
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // --- 1. (需求) 加载网络圆形头像 ---
              _buildAvatar(),

              SizedBox(height: 16.h),

              // (推荐)
              //    在头像下面显示用户名
              Obx(
                () => Text(
                  controller.user.value?.loginResultEntityOperator.name ?? '游客',
                  // (假设你的实体类有 'username')
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 60.h), // (拉开一点距离)
              // --- 2. (需求) 退出登录按钮 ---
              OutlinedButton.icon(
                icon: Icon(Icons.logout),
                label: Text(
                  'profile_logout'.tr,
                  style: TextStyle(fontSize: 16.sp),
                ),

                // (核心)
                //    点击时, 调用 Logic 的方法
                //    它 *不* 知道什么是 Dialog, 什么是导航
                onPressed: controller.showLogoutDialog,

                // (推荐)
                //    给它一个"危险"的红色样式
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h), // (占满宽度)
                  foregroundColor: Colors.red, // 文本和图标颜色
                  side: BorderSide(color: Colors.red.shade300), // 边框颜色
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// (辅助)
  /// 抽离出一个“头像” Widget
  Widget _buildAvatar() {
    // (核心)
    //    Obx 监听 'controller.user' 的变化
    //    (例如: 登录时, 或用户更新头像时)
    final String? avatarUrl =
        "https://img.ixintu.com/download/jpg/202304/7b60f7ea3c5b2b5d36315a1627b257a8_260_178.jpg!con";

    final Widget fallbackImageWidget = Image(
      image: Assets.images.defaultAvatar.image().image,
      fit: BoxFit.cover,
    );

    // 4. (核心)
    //    我们不再使用 CircleAvatar, 而是 ClipOval + CachedNetworkImage
    //    这让我们能*完全*控制 加载/失败/占位 状态
    return ClipOval(

      // (适配)
      //    匹配你之前的 CircleAvatar(radius: 60.r)
      //    (直径是 120)
      child: Container(
        width: 120.r,
        height: 120.r,
        color: Colors.grey.shade200, // (这是占位图的背景色)

        child: CachedNetworkImage(
          // (A) 你的网络图片 URL
          //     (如果 url 是 null 或空, errorWidget 会被触发)
          imageUrl: avatarUrl ?? "",

          // (B) (适配)
          //     确保图片填满这个圆
          fit: BoxFit.cover,

          // (C) (你的需求)
          //     "占位图" (加载时显示)
          placeholder: (context, url) => Center(
            child: fallbackImageWidget
          ),

          // (D) (核心)
          //     "失败图" (替代你之前的 onBackgroundImageError)
          //     (当 URL 为 null, 空, 或 404 时触发)
          errorWidget: (context, url, error) {

            // (日志)
            //    你仍然可以在这里打日志
            if (avatarUrl != null && avatarUrl.isNotEmpty) {
              logger.w("加载头像失败: $avatarUrl", error: error);
            }

            // (UI)
            //    返回你的本地占位图
            return fallbackImageWidget;
          },
        ),
      ),
    );
  }
}

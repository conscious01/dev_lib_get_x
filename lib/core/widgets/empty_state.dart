import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// (核心)
/// 一个可复用的"空"
/// 布局
class EmptyStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const EmptyStateWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 80.r,
              color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              message ?? 'empty_data'.tr, // (例如:
              //  "暂无数据")
              style: TextStyle(fontSize: 16.sp,
                  color: Colors.grey[600]),
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('retry'.tr), // (例如:
              //  "重试")
            )
          ]
        ],
      ),
    );
  }
}
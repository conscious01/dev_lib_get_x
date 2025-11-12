import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension WidgetExtensions on Widget {

  // --- (不变) Center ---
  /// 以前: Center(child: Text("..."))
  /// 现在: Text("...").center()
  Widget center() {
    return Center(child: this);
  }

  // --- (不变) Padding ---

  /// 快速添加一个 'Padding' (所有方向)
  /// (使用 .r 适配)
  /// 以前: Padding(padding: EdgeInsets.all(16.r), child: ...)
  /// 现在: (...).paddingAll(16)
  Widget paddingAllD(double value) {
    return Padding(padding: EdgeInsets.all(value.r), child: this);
  }

  /// 快速添加 'Padding' (水平)
  /// (使用 .w 适配)
  Widget paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value.w),
      child: this,
    );
  }

  /// 快速添加 'Padding' (垂直)
  /// (使用 .h 适配)
  Widget paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value.h),
      child: this,
    );
  }


  // --- (核心) (新增!) Margin ---
  //
  // (注意: 我们必须使用 'Container' 来实现 'margin')

  /// (新增!)
  /// 快速添加一个 'Margin' (所有方向)
  /// (使用 .r 适配)
  ///
  /// 以前: Container(margin: EdgeInsets.all(16.r), child: ...)
  /// 现在: (...).marginAll(16)
  Widget marginAll(double value) {
    return Container(
      margin: EdgeInsets.all(value.r),
      child: this,
    );
  }

  /// (新增!)
  /// 快速添加 'Margin' (水平)
  /// (使用 .w 适配)
  Widget marginHorizontal(double value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: value.w),
      child: this,
    );
  }

  /// (新增!)
  /// 快速添加 'Margin' (垂直)
  /// (使用 .h 适配)
  Widget marginVertical(double value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: value.h),
      child: this,
    );
  }
}
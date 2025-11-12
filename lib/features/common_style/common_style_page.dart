import 'package:dev_lib_getx/core/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common_style_logic.dart';

class CommonStylePage extends GetView<CommonStyleLogic> {
  const CommonStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CommonStylePage")),
      body: Column(
        children: [
          SizedBox(height: 26.h),
          Text("This is a Text").center(),
          SizedBox(height: 26.h),
          Container(
            // (不变)
            // 1.
            //    外层 Indigo Container (背景)
            width: double.infinity,
            color: Colors.indigo.shade300,

            // (核心!)
            // 2.
            //    用 'Align' 替换 'Center'
            child: Align(
              // (核心!)
              // 3.
              //    告诉它"对齐到右侧中间"
              alignment: Alignment.centerRight,

              // 4. (不变)
              //    你的 Red Container
              //    现在会"包裹内容" *并且* "贴住右边"
              child: Container(
                color: Colors.black,
                child: Text("data", style: TextStyle(color: Colors.white)),
              ).paddingAllD(20.r),
            ),
          ),
        ],
      ),
    );
  }
}

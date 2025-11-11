

import 'package:dev_lib_getx/features/second/second_logic.dart';
import 'package:dev_lib_getx/features/send_event/send_event_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SendEventPage extends GetView<SendEventLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SendEventPage")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child:  Row(
            children: [
              // (核心) 1.
              //    用 Expanded 包裹, 防止溢出
              Expanded(
                child: TextField(
                  controller: controller.eventController,
                  decoration: InputDecoration(labelText: "input_any".tr),
                ),
              ),

              SizedBox(width: 16.w),

              // (核心) 2.
              //    连接 'onPressed'
              ElevatedButton(
                child: Text("send_event_2_other_page".tr),
                onPressed: () {
                  // (核心)
                  //    调用 Logic (控制器) 的方法
                  controller.sendEvent();
                },
              ),
            ],
          ),
        ),
      ),
    );

  }
}

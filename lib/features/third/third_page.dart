import 'package:dev_lib_getx/features/prifile/profile_logic.dart';
import 'package:dev_lib_getx/features/third/third_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThirdPage extends GetView<ThirdLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ThirdPage Title"),),
      body: Obx(() {
        return Center(child: Text(controller.eventData.toString()));
      }),
    );
  }
}

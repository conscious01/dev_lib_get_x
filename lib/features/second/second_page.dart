import 'package:dev_lib_getx/features/splash/splash_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondPage extends GetView<SplashLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Page Title"),),
      body: Center(child: Text("SecondPage")),
    );
  }
}

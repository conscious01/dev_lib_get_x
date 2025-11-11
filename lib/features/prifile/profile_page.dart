import 'package:dev_lib_getx/features/prifile/profile_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ProfilePage Title"),),
      body: Center(child: Text("ProfilePage")),
    );
  }
}

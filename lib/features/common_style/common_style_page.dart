import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_style_logic.dart';

class CommonStylePage extends GetView<CommonStyleLogic> {
  const CommonStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CommonStylePage")),
      body: Center(
        child: Text("CommonStylePage"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'list_page_logic.dart';

class ListPage extends GetView<ListPageLogic> {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListPage")),
      body: Center(
        child: Text("ListPage"),
      ),
    );
  }
}

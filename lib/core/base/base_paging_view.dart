import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/empty_state.dart';
import 'base_paging_logic.dart';

abstract class BasePagingView<L extends BasePagingLogic<T>, T>
    extends GetView<L> {
  const BasePagingView({super.key});

  String get title;

  Widget buildItem(BuildContext context, T item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title.tr)),

      body: controller.obx(
        (listData) => SafeArea(
          child: SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: controller.canLoadMore,

            onRefresh: controller.onRefresh,
            onLoading: controller.onLoadMore,

            child: ListView.builder(
              itemCount: listData!.length,
              itemBuilder: (context, index) {
                return buildItem(context, listData[index]);
              },
            ),
          ),
        ),

        onLoading: const Center(child: CircularProgressIndicator()),

        onEmpty: EmptyStateWidget(
          message: 'empty_data'.tr,
          onRetry: controller.fetchFirstPage,
        ),

        onError: (errorString) => EmptyStateWidget(
          message: "加载失败: $errorString",
          onRetry: controller.fetchFirstPage,
        ),
      ),
    );
  }
}

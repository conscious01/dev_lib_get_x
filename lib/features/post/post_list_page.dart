import 'package:dev_lib_getx/features/post/post_item_card.dart';
import 'package:dev_lib_getx/features/post/post_list_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/widgets/empty_state.dart';

class PostListPage extends GetView<PostListLogic> {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("list_page_manually".tr)),

      body: controller.obx(
        (postList) => SafeArea(
          child: SmartRefresher(
            controller: controller.refreshController,

            enablePullDown: true,
            enablePullUp: controller.canLoadMore,

            onRefresh: controller.onRefresh,

            onLoading: controller.onLoadMore,

            child: ListView.builder(
              itemCount: postList!.length,
              itemBuilder: (context, index) {
                final post = postList[index];

                return PostItemCard(
                  post: post,
                  onLikeTap: () {
                    controller.updateItemState(post.title);
                  },
                );
              },
            ),
          ),
        ),

        onLoading: const Center(child: CircularProgressIndicator()),

        onEmpty: EmptyStateWidget(
          message: "没有找到帖子",
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

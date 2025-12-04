import 'package:dev_lib_getx/features/article/article_list_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/base/base_paging_view.dart';
import '../../models/post_entity.dart';
import '../post/post_item_card.dart';
import 'article_item_card.dart';

class ArticleListPage extends BasePagingView<ArticleListLogic, PostEntity> {
  const ArticleListPage({super.key});

  @override
  String get title => 'list_page_use_base'.tr;

  @override
  Widget buildItem(BuildContext context, PostEntity item) {
    return ArticleItemCard(
      post: item,
      onLikeTap: () {
        controller.updateItemState(item.title);
      },
    );
  }
}

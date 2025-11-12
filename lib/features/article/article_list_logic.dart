import 'package:get/get.dart';

import '../../core/base/base_paging_logic.dart';
import '../../core/constants/api_config.dart';
import '../../models/post_entity.dart';

class ArticleListLogic extends BasePagingLogic<PostEntity> {
  @override
  Future<List<PostEntity>> fetchPageData(int page, int pageSize) async {
    return networkRepo.getData<List<PostEntity>>(
      ApiConfig.getPostListPaged,
      queryParameters: {'page': page, 'limit': pageSize},
      fromJsonT: (json) =>
          (json as List).map((e) => PostEntity.fromJson(e)).toList(),
      showLoading: false,
      showToast: false,
    );
  }

  void updateItemState(String title) {
    if (state == null) return;
    final newList = state!.map((post) {
      if (post.title == title) {
        return post.copyWith(isLiked: !post.isLiked);
      }
      return post;
    }).toList();
    change(newList, status: RxStatus.success());
  }
}

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/api_config.dart';
import '../../core/repository/network_repository.dart';
import '../../core/services/dialog_service.dart';
import '../../models/post_entity.dart';

class PostListLogic extends GetxController with StateMixin<List<PostEntity>> {
  final DialogService _dialog = Get.find<DialogService>();
  final NetworkRepository networkRepo = Get.find<NetworkRepository>();
  final RefreshController refreshController = RefreshController();

  int _currentPage = 1;
  final int _pageSize = 10;
  bool canLoadMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchFirstPage();
  }

  Future<List<PostEntity>> _fetchPosts(int page) async {
    final List<PostEntity> result = await networkRepo.getData<List<PostEntity>>(
      ApiConfig.getPostListPaged,
      queryParameters: {'page': page, 'limit': _pageSize},
      fromJsonT: (json) =>
          (json as List).map((e) => PostEntity.fromJson(e)).toList(),
      showLoading: false,
      showToast: false,
    );
    return result;
  }

  Future<void> fetchFirstPage() async {
    change(null, status: RxStatus.loading());
    _currentPage = 1;

    try {
      final List<PostEntity> result = await _fetchPosts(_currentPage);

      if (result.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
        canLoadMore = result.length == _pageSize;
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> onRefresh() async {
    _currentPage = 1;

    try {
      final List<PostEntity> result = await _fetchPosts(_currentPage);

      if (result.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
        canLoadMore = result.length == _pageSize;
      }

      refreshController.refreshCompleted();
      if (!canLoadMore) {
        refreshController.loadNoData();
      }
    } catch (e) {
      refreshController.refreshFailed();
      _dialog.showErrorToast("刷新失败:$e");
    }
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore) {
      refreshController.loadNoData();
      return;
    }
    _currentPage++;

    try {
      final List<PostEntity> result = await _fetchPosts(_currentPage);

      if (result.isEmpty) {
        canLoadMore = false;
        refreshController.loadNoData();
      } else {
        change(state! + result, status: RxStatus.success());
        canLoadMore = result.length == _pageSize;
        refreshController.loadComplete();
      }
    } catch (e) {
      _currentPage--;

      refreshController.loadFailed();
    }
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

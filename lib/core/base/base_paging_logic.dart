import 'package:dev_lib_getx/core/repository/network_repository.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/dialog_service.dart';

// (核心)
// 1.
//    (T)
//    是一个泛型 (Generic),
//    它代表*列表项*的
//    实体
//    (例如 PostEntity
//    或 MessageEntity)
abstract class BasePagingLogic<T> extends GetxController
    with StateMixin<List<T>> {
  // ---
  // 1.
  //    (封装)
  //    所有 Logic
  //    都共用的服务
  // ---
  // (我们假设 Logic
  //  内部会 'find'
  //  它们,
  //  所以用 'late final')
  late final NetworkRepository networkRepo;
  late final DialogService dialogService;

  // ---
  // 2.
  //    (封装)
  //    所有*分页* Logic
  //    都共用的状态
  // ---
  final RefreshController refreshController = RefreshController();
  int _currentPage = 1;
  final int _pageSize = 10; // (你也可以让子类覆盖这个)
  bool canLoadMore = true;

  // (核心)
  // 3.
  //    (!!
  //    关键
  //    !!)
  //    *抽象*方法:
  //    "如何获取数据"
  //
  //    *子*类 (PostListLogic,
  //    MessageListLogic)
  //    *必须*覆盖 (override)
  //    这个方法,
  //    并提供*真正*的 API
  //    调用
  Future<List<T>> fetchPageData(int page, int pageSize);

  @override
  void onInit() {
    super.onInit();
    // (注入)
    //    (我们使用"服务定位",
    //    而不是"构造函数注入",
    //    来让基类更简单)
    networkRepo = Get.find<NetworkRepository>();
    dialogService = Get.find<DialogService>();

    // (启动)
    fetchFirstPage();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // ---
  // 4.
  //    (封装)
  //    *通用*的
  //    'fetchFirstPage'
  //    逻辑
  // ---
  Future<void> fetchFirstPage() async {
    change(null, status: RxStatus.loading()); // (A)
    // 全屏 Loading
    _currentPage = 1;

    try {
      // (核心)
      //    (B)
      //    调用那个*抽象*的方法
      final List<T> result = await fetchPageData(_currentPage, _pageSize);

      // (C)
      //    (不变)
      //    检查空/
      //    成功
      if (result.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
        canLoadMore = result.length == _pageSize;
      }
    } catch (e) {
      // (D)
      //    (不变)
      //    全屏 Error
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  // ---
  // 5.
  //    (封装)
  //    *通用*的
  //    'onRefresh'
  //    逻辑
  // ---
  Future<void> onRefresh() async {
    _currentPage = 1;

    try {
      // (核心)
      //    (A)
      //    *调用*那个*抽象*的方法
      final List<T> result = await fetchPageData(_currentPage, _pageSize);

      if (result.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
        canLoadMore = result.length == _pageSize;
      }

      // (B)
      //    (不变)
      //    管理 Controller
      refreshController.refreshCompleted();
      if (!canLoadMore) {
        refreshController.loadNoData();
      }
    } catch (e) {
      refreshController.refreshFailed();
      dialogService.showErrorToast("刷新失败:$e");
    }
  }

  // ---
  // 6.
  //    (封装)
  //    *通用*的
  //    'onLoadMore'
  //    逻辑
  // ---
  Future<void> onLoadMore() async {
    if (!canLoadMore) {
      refreshController.loadNoData();
      return;
    }
    _currentPage++;

    try {
      // (核心)
      //    (A)
      //    *调用*那个*抽象*的方法
      final List<T> result = await fetchPageData(_currentPage, _pageSize);

      if (result.isEmpty) {
        canLoadMore = false;
        refreshController.loadNoData();
      } else {
        // (B)
        //    (不变)
        //    *追加*数据
        change(state! + result, status: RxStatus.success());
        canLoadMore = result.length == _pageSize;
        refreshController.loadComplete();
      }
    } catch (e) {
      _currentPage--;
      refreshController.loadFailed();
    }
  }
}

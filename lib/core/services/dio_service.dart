import 'package:dev_lib_getx/core/services/logger_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../routes/app_routes.dart';
import '../constants/api_endpoints.dart';
import '../widgets/loading_dialog.dart';
import 'app_data_service.dart';
import 'storage_service.dart'; // 1. (依赖) 导入 StorageService



class AppDioInterceptor extends Interceptor {

  // 依赖注入 (DI)
  final StorageService storage = Get.find<StorageService>();
  final AppDataService appData = Get.find<AppDataService>();

  // (核心)
  // 用于跟踪当前有多少个请求正在进行
  // 以防止 Loading 弹窗过早关闭
  int _requestCount = 0;

  // --- (A) 请求拦截 ---
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    // 1. (核心)
    //    从 AppDataService 或 StorageService 读取 Token
    //    (我们假设 AppDataService 在内存中持有它)
    final token = appData.currentUser.value?.msg; // (假设你的实体类有 token)
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 2. (核心)
    //    显示 Loading 弹窗 (Feature 1)

    // (可选) 检查是否需要显示 loading
    final bool showLoading = options.extra['showLoading'] ?? true;

    if (showLoading) {
      _requestCount++;
      // (关键) 只有在第一个请求发起时才显示
      if (_requestCount == 1) {
        Get.dialog(
          const LoadingDialog(), // (一个简单的转圈 Widget)
          barrierDismissible: false, // 不允许点击外部关闭
        );
      }
    }

    return handler.next(options);
  }

  // --- (B) 响应拦截 ---
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    // 1. (核心) 关闭 Loading (Feature 1)
    final bool showLoading = response.requestOptions.extra['showLoading'] ?? true;
    if (showLoading) {
      _requestCount--;
      // (关键) 只有在所有请求都完成后才关闭
      if (_requestCount == 0) {
        Get.back(); // 关闭 Get.dialog
      }
    }

    // 2. (核心)
    //    在这里处理 'code != 200' 的 Toast (Feature 3 & 4)
    try {
      // (注意) Dio 默认会把 JSON 解码为 Map
      Map<String, dynamic> data = response.data;

      // (假设) 你的 code 字段是 int
      int code = data['code'];
      String msg = data['msg'] ?? '未知错误';

      // (关键) 检查是否需要显示 Toast
      final bool showToast = response.requestOptions.extra['showToast'] ?? true;

      if (code != 200 && showToast) {
        // (核心) 显示 Toast
        Get.snackbar(
          "请求失败 ($code)",
          msg,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }

    } catch (e) {
      logger.w("Dio Response: 解析响应体失败: $e");
    }

    return handler.next(response);
  }

  // --- (C) 错误拦截 ---
  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    logger.e("Dio Error: [${e.response?.statusCode}] ${e.requestOptions.path}", error: e);

    // 1. (核心) 关闭 Loading (Feature 1)
    final bool showLoading = e.requestOptions.extra['showLoading'] ?? true;
    if (showLoading) {
      _requestCount = 0; // 发生错误时, 重置计数器并关闭
      Get.back();
    }

    // 2. (核心) 处理 401 (Token 失效)
    if (e.response?.statusCode == 401) {
      // (关键) 调用 AppDataService 登出,
      //        它会清除内存和磁盘
      appData.signOut();
      // (关键) 强制跳转到登录页
      Get.offAllNamed(AppRoutes.authLogin);
      Get.snackbar("会话已过期", "请重新登录");

      // (重要) 我们"解决"了这个错误,
      //        所以我们不应该 'next(e)'
      //        而是创建一个虚拟的 Response
      return handler.resolve(
          Response(requestOptions: e.requestOptions, data: null, statusCode: 200)
      );
    }

    // 3. (核心)
    //    处理其他错误 (超时, 没网络, 500)
    //    (Feature 3 & 4)
    final bool showToast = e.requestOptions.extra['showToast'] ?? true;
    if (showToast) {
      Get.snackbar(
        "网络错误",
        e.message ?? "无法连接到服务器",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }

    return handler.next(e);
  }
}



class DioService extends GetxService {

  // (核心) 依赖注入 StorageService
  final StorageService _storage;
  DioService({required StorageService storage}) : _storage = storage;

  // 'late' 保证它在 onInit 中被初始化
  late final Dio _dio;

  // (核心) 将配置好的 Dio 实例暴露出去
  // 这样 AppRepository 就可以通过 Get.find<DioService>().dio 来使用它
  Dio get dio => _dio;

  // onInit 是 GetxService 的生命周期方法,
  // 它在 Get.put() 时被调用
  @override
  void onInit() {
    super.onInit();

    // 1. (配置) Dio 的基础配置
    final options = BaseOptions(
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      baseUrl: ApiEndpoints.baseUrl,
      responseType: ResponseType.json,
    );

    // 2. (创建) 创建 Dio 实例
    _dio = Dio(options);

    // 3. (核心) 添加拦截器
    _dio.interceptors.add(AppDioInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          // --- (A) 打印"请求" ---
          request: true,
          requestHeader: true,
          // (核心) 打印你 POST 的 JSON
          requestBody: true,

          // --- (B) 打印"响应" ---
          responseHeader: true,
          // (核心) 打印 API 返回的 JSON
          responseBody: true,

          // --- (C) 打印"错误" ---
          error: true,

          // --- (D) (关键!) ---
          //    重定向 dio 的 'print' 到你的 'logger'
          //    这样你的日志级别、颜色等都会生效
          // logPrint: (obj) => logger.d(obj.toString()),
        ),
      );
    }
  }
}
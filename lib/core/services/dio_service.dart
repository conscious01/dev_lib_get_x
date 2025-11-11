import 'dart:io';

import 'package:dev_lib_getx/core/services/logger_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../../routes/app_routes.dart';
import '../constants/api_config.dart';
import '../widgets/loading_dialog.dart';
import 'app_data_service.dart';
import 'storage_service.dart'; // 1. (依赖) 导入 StorageService

class AppDioInterceptor extends Interceptor {
  // 依赖注入 (DI)
  final StorageService storage = Get.find<StorageService>();
  final AppDataService appData = Get.find<AppDataService>();

  // 用于跟踪当前有多少个请求正在进行
  // 以防止 Loading 弹窗过早关闭
  int _requestCount = 0;

  // --- (A) 请求拦截 ---
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. (核心)
    // header添加请求头token
    final token = "takeToken";
    options.headers['token'] = 'Bearer $token';

    // 2. (核心)
    //    显示 Loading 弹窗 (Feature 1)
    // (可选) 检查是否需要显示 loading
    final bool showLoading = options.extra[ApiConfig.showLoading] ?? true;

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
    final bool showLoading =
        response.requestOptions.extra[ApiConfig.showLoading] ?? true;
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
      int code = data[ApiConfig.resCode];
      String msg = data[ApiConfig.resMsg] ?? 'network_error_unknown'.tr;

      // (关键) 检查是否需要显示 Toast
      final bool showToast =
          response.requestOptions.extra[ApiConfig.showToast] ?? true;

      if (code != 200 && showToast) {
        // (核心) 显示 Toast
        var title = "network_error_failed_code_is".trParams({
          "code": code.toString(),
        });

        Get.snackbar(
          title,
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

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    logger.e(
      "Dio Error: [${e.response?.statusCode}] ${e.requestOptions.path}",
      error: e,
    );

    // 1. (不变) 关闭 Loading
    final bool showLoading =
        e.requestOptions.extra[ApiConfig.showLoading] ?? true;
    if (showLoading) {
      _requestCount = 0;
      Get.back();
    }

    // 2. (不变) 处理 401 (Token 失效)
    if (e.response?.statusCode == 401) {
      appData.signOut();
      Get.offAllNamed(AppRoutes.authLogin);
      Get.snackbar("会话已过期", "请重新登录");
      return handler.resolve(
        Response(requestOptions: e.requestOptions, data: null, statusCode: 200),
      );
    }

    // (A) (关键!) 检查是否需要显示 Toast
    final bool showToast = e.requestOptions.extra[ApiConfig.showToast] ?? true;
    if (showToast) {
      // (B) (关键!)
      //    不再使用 e.message,
      //    而是调用我们的"错误翻译器"
      final String friendlyMessage = _getFriendlyErrorMessage(e);

      Get.snackbar(
        "network_error_request_failed".tr, // (一个统一的标题)
        friendlyMessage, // (核心!) 使用"友好"的提示
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    return handler.next(e);
  }

  // (核心!)
  // 4. (新增!)
  //    "DioException 错误翻译器"
  //    它将技术错误转换为用户友好的提示
  String _getFriendlyErrorMessage(DioException e) {
    // (核心)
    // 我们检查 DioExceptionType
    switch (e.type) {
      // (A) 网络连接/DNS错误/连接被拒
      //     (Dio 5.x 之前是 DioErrorType.other)
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown: // (兜底)
        // (可选) 我们可以更深入地检查 SocketException
        if (e.error is SocketException) {
          return "network_error_socket_exception".tr;
        }
        return "network_error_exception_unknown".tr;

      // (B) 连接超时
      case DioExceptionType.connectionTimeout:
        return "network_error_timeout";

      // (C) 响应超时
      case DioExceptionType.receiveTimeout:
        return "network_error_receive_timeout";

      // (D) 发送超时
      case DioExceptionType.sendTimeout:
        return "network_error_send_timeout".tr;

      // (E) 4xx / 5xx 错误
      case DioExceptionType.badResponse:
        // (注意) 401 已经在上面被处理了
        if (e.response?.statusCode == 500 ||
            e.response?.statusCode == 502 ||
            e.response?.statusCode == 503) {
          return "network_error_5_code"; // (5xx 统一提示)
        }
        // 404, 403, 400 (业务错误)
        // 我们的 AppRepository 会*抛出* ApiException
        // Interceptor 已经弹了 Toast ('msg' 字段)
        // 所以在这里我们返回一个*通用*的

        var msg = "network_error_failed_code_is".trParams({
          "code": (e.response?.statusCode).toString(),
        });

        return msg;

      // (F) 请求被取消
      case DioExceptionType.cancel:
        return "network_error_cancel".tr;
      default:
        return "network_error_unknown".tr;
    }
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
      baseUrl: ApiConfig.baseUrl,
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

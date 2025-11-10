import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/base_response_entity.dart';
import '../services/dio_service.dart';

// (核心)
// 这是一个辅助类, 用于封装 API 的 'msg'
// 这样 Controller 就能捕获到它
class ApiException implements Exception {
  final String message;
  final int code;

  ApiException(this.message, this.code);

  @override
  String toString() => message;
}

class AppRepository {
  final Dio _dio = Get.find<DioService>().dio;

  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true,
  }) {
    return _requestData<T>(
      path,
      method: 'GET',
      // <-- 'method' 在这里被封装了
      queryParameters: queryParameters,
      fromJsonT: fromJsonT,
      showLoading: showLoading,
      showToast: showToast,
    );
  }

  /// 封装 POST 请求
  Future<T> postData<T>(
    String path, {
    dynamic data, // (POST 通常用 data, 而不是 queryParameters)
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true,
  }) {
    return _requestData<T>(
      path,
      method: 'POST',
      // <-- 'method' 在这里被封装了
      data: data,
      fromJsonT: fromJsonT,
      showLoading: showLoading,
      showToast: showToast,
    );
  }

  Future<T> _requestData<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT, // (关键)
    bool showLoading = true, // (Feature 1)
    bool showToast = true, // (Feature 4)
  }) async {
    // (核心) 1.
    //    调用 Dio, 并传递 'extra' 选项
    final response = await _dio.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        extra: {'showLoading': showLoading, 'showToast': showToast},
      ),
    );

    // (核心) 2.
    //    (Feature 2)
    //    在这里使用 BaseResponseEntity 进行*真正*的解析
    final BaseResponseEntity<T> baseResponse = BaseResponseEntity.fromJson(
      response.data,
      fromJsonT,
    );

    // (核心) 3.
    //    (Feature 6)
    //    检查 code, 只返回 'data'
    if (baseResponse.code == 200) {
      // (如果 data 为 null 也许也该抛错? 这取决于你的业务)
      if (baseResponse.data == null) {
        throw ApiException("数据为空", baseResponse.code);
      }
      return baseResponse.data!;
    } else {
      // (核心) 4.
      //    (Feature 3)
      //    Interceptor 已经显示了 Toast (如果 showToast=true)
      //    这里我们只管 *抛出* 异常,
      //    让 Logic (控制器) 的 'catch' 块去处理
      throw ApiException(baseResponse.msg, baseResponse.code);
    }
  }

  // --- (核心) 你的 10% 的请求会调用这个方法 ---

  /// (Feature 5)
  ///
  /// 当你需要*自己*处理 'code' (例如 1001 = "需要验证")
  /// 这个方法会返回*完整*的 BaseResponseEntity
  Future<BaseResponseEntity<T>> getFullResponse<T>(
    String path, {
    /* ... (和上面一样的参数) ... */
    required T Function(Object? json) fromJsonT,
  }) async {
    final response = await _dio.request(path /* ... (和上面一样的 options) ... */);

    // (核心)
    // 它只管解析, 不管 code 是多少, 直接返回
    return BaseResponseEntity.fromJson(response.data, fromJsonT);
  }
}

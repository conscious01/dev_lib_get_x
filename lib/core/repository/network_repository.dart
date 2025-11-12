import 'package:dev_lib_getx/core/services/logger_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/api_config.dart';
import '../models/base_response_entity.dart';
import '../services/dio_service.dart';

// (核心)
// 这是一个辅助类, 用于封装 API 的 'msg'
// 这样 Controller 就能捕获到它
class ApiException implements Exception {
  final int code;
  final String message;
  final dynamic data;

  ApiException(this.code, this.message, {this.data});

  @override
  String toString() {
    return 'ApiException=>{code: $code, message: $message, data: $data}';
  }
}

class NetworkRepository {
  final Dio _dio = Get.find<DioService>().dio;

  // --- (A) 90% 的情况: Logic 调用这些 (只返回 T) ---
  /// (公共) GET 请求 - 只返回 'data' (T)
  /// (如果 code != successCode, 会抛出 ApiException)
  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true,
  }) async {
    final baseResponse = await _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      fromJsonT: fromJsonT,
      showLoading: showLoading,
      showToast: showToast,
    );

    if (baseResponse.code == ApiConfig.successCode) {
      if (baseResponse.data == null) {
        throw ApiException(
          baseResponse.code,
          "data数据为空",
          data: baseResponse.data,
        );
      }

      return baseResponse.data!;
    } else {
      throw ApiException(
        baseResponse.code,
        baseResponse.msg,
        data: baseResponse.data,
      );
    }
  }

  /// (公共) POST 请求 - 只返回 'data' (T)
  Future<T> postData<T>(
    String path, {
    dynamic parameter,
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true,
  }) async {
    final baseResponse = await _request<T>(
      path,
      method: 'POST',
      parameter: parameter,
      fromJsonT: fromJsonT,
      showLoading: showLoading,
      showToast: showToast,
    );

    // (同上) 检查业务 code
    if (baseResponse.code == ApiConfig.successCode) {
      if (baseResponse.data == null) {
        throw ApiException(
          baseResponse.code,
          "data数据为空",
          data: baseResponse.data,
        );
      }
      return baseResponse.data!;
    } else {
      throw ApiException(
        baseResponse.code,
        baseResponse.msg,
        data: baseResponse.data,
      );
    }
  }

  // --- (B) 10% 的情况: Logic 调用这些 (返回 BaseResponseEntity<T>) ---
  /// (公共) GET - 返回 *完整* 的 BaseResponseEntity
  /// (这个方法 *永远不会* 抛出 ApiException)
  Future<BaseResponseEntity<T>> getDataWithFullRes<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true, // (注意: code!=200 依然会 Toast)
  }) {
    // (核心)
    // 它只是“核心”方法的一个"别名"
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      fromJsonT: fromJsonT,
      showLoading: showLoading,
      showToast: showToast,
    );
  }

  /// (公共) POST - 返回 *完整* 的 BaseResponseEntity
  Future<BaseResponseEntity<T>> postDataWithFullRes<T>(
    String path, {
    dynamic data,
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true,
  }) {
    return _request<T>(
      path,
      method: 'POST',
      parameter: data,
      fromJsonT: fromJsonT,
      showLoading: showLoading,
      showToast: showToast,
    );
  }

  // --- (C) (核心)
  //    *私有* 的、*唯一* 的网络请求方法
  //    (已融合你的 ApiConfig 常量)
  // ---
  Future<BaseResponseEntity<T>> _request<T>(
    String path, {
    required String method,
    dynamic parameter,
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT,
    bool showLoading = true,
    bool showToast = true,
  }) async {
    final response = await _dio.request(
      path,
      data: parameter,
      queryParameters: queryParameters,
      options: Options(
        method: method,

        extra: {
          ApiConfig.showLoading: showLoading,
          ApiConfig.showToast: showToast,
        },
      ),
    );

    //    安全地解析*原始* Map
    Map<String, dynamic> rawData = response.data;

    // ✅ (回答你的 //todo)
    //    "其他的参数是否可以为空"
    //    如果 resCode 或 resMsg 为 null, (as int?) 会安全处理
    int code = rawData[ApiConfig.resCode] as int? ?? -1; // (安全)
    String msg = rawData[ApiConfig.resMsg] as String? ?? '未知错误'; // (安全)
    dynamic responseData = rawData[ApiConfig.resData]; // (安全)

    T? dataEntity;

    try {
      dataEntity = fromJsonT(responseData);
    } catch (e) {
      logger.e(e);

      // (健壮性)
      //    即使 code=200,
      //    服务器返回的 'data' 字段也可能格式错误
      //    我们必须捕获它, 并把它当作一个"业务错误"
      return BaseResponseEntity(
        code: -1, // (自定义一个"解析失败"代码)
        msg: "数据解析失败: $e",
        data: null,
      );
    }

    // (核心) 4.
    //    *返回* 完整的、已解析的实体
    //    (如果 code!=200, dataEntity 会是 null)
    return BaseResponseEntity(code: code, msg: msg, data: dataEntity);
  }
}

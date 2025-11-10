import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'storage_service.dart'; // 1. (依赖) 导入 StorageService
import '../../routes/app_pages.dart'; // 2. (依赖) 导入路由, 用于 401 跳转

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
      connectTimeout: Duration(seconds: 10), // 10 秒连接超时
      receiveTimeout: Duration(seconds: 10), // 10 秒接收超时

      // (可选) 你的 API base Url, 这样 AppRepository 中就只用写 /login
      // baseUrl: "https://api.example.com"

      // (推荐) 根据响应内容自动选择解析器
      responseType: ResponseType.json,
    );

    // 2. (创建) 创建 Dio 实例
    _dio = Dio(options);

    // 3. (核心) 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(

        // --- (A) 请求拦截 ---
        onRequest: (options, handler) {
          print("Dio Request: [${options.method}] ${options.path}");

          // (关键) 从 StorageService 读取 Token
          final token = _storage.readString('token');

          if (token != null) {
            // (关键) 如果 Token 存在, 将它添加到请求头中
            options.headers['Authorization'] = 'Bearer $token';
          }

          // (关键) 继续执行请求
          return handler.next(options);
        },

        // --- (B) 响应拦截 ---
        onResponse: (response, handler) {
          print("Dio Response: [${response.statusCode}] ${response.requestOptions.path}");

          // (可选) 你可以在这里做全局的数据转换

          return handler.next(response); // 继续
        },

        // --- (C) 错误拦截 ---
        onError: (e, handler) {
          print("Dio Error: [${e.response?.statusCode}] ${e.requestOptions.path}");

          // (关键) 处理 401 (Token 失效)
          if (e.response?.statusCode == 401) {

            // 1. 清除本地 Token
            _storage.clearAll();

            // 2. (关键) 强制跳转到登录页
            //    使用 offAllNamed 确保用户不能“返回”到需要登录的页面
            Get.offAllNamed(AppRoutes.authLogin);

            // (可选) 弹出一个提示
            Get.snackbar("会话已过期", "请重新登录");
          }

          // (关键) 让错误继续传递
          // 这样 Repository 中的 try/catch 才能捕获到它
          return handler.next(e);
        },

      ),
    );
  }
}
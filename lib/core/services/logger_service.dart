import 'package:get/get.dart';
import 'package:logger/logger.dart';

Logger get logger => Get.find<LoggerService>().log;

// 这是一个轻量级的服务, 只负责提供一个配置好的 Logger 实例
class LoggerService extends GetxService {

  // (核心) 向 GetX 暴露这个 Logger 实例
  late final Logger _log;
  Logger get log => _log;

  // (高阶)
  // onInit 会在 Get.put() 时被调用
  // 我们在这里根据环境配置 Logger
  @override
  void onInit() {
    super.onInit();

    // 默认日志级别
    Level logLevel = Level.verbose; // (默认)

    // (高阶)
    // 我们可以尝试 'find' AppConfig, 但它可能在 Logger 之后注入
    // 更好的方法是让 main.dart 把 AppConfig 传进来
    // 但为了简单, 我们假设 AppConfig 已经被注入
    try {
      logLevel = Level.trace;
    } catch (e) {
      print("LoggerService: AppConfig 未找到, 使用默认日志级别 (Verbose)");
    }

    // (核心) 初始化 Logger
    _log = Logger(
      // (核心) 设置日志级别
      level: logLevel,

      // (核心) 使用漂亮的打印机
      printer: PrettyPrinter(
        methodCount: 1, // 只显示 1 层堆栈
        errorMethodCount: 8, // 错误时显示 8 层
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
    );

    // 打印第一条日志
    _log.i("LoggerService 已初始化, 日志级别: $logLevel");
  }
}
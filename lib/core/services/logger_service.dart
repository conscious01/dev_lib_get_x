import 'package:get/get.dart';
import 'package:logger/logger.dart';

Logger get logger => Get.find<LoggerService>().log;

class LoggerService extends GetxService {
  late final Logger _log;

  Logger get log => _log;

  @override
  void onInit() {
    super.onInit();
    Level logLevel = Level.trace;

    _log = Logger(
      level: logLevel,

      printer: PrettyPrinter(
        methodCount: 1,

        errorMethodCount: 8,

        lineLength: 90,

        colors: true,

        printEmojis: false,

      ),
    );
    _log.i("LoggerService 已初始化,日志级别: $logLevel");
  }
}

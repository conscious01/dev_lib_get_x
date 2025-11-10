import 'package:dev_lib_getx/core/models/login_request.dart';
import 'package:dev_lib_getx/core/services/logger_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/repository/app_repository.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';

class LoginLogic extends GetxController {
  // 1. (DI) 接收 Repository
  final AppRepository appRepo;
  final StorageService storage; // (假设你也需要存储)

  // (构造函数注入)
  LoginLogic({required this.appRepo, required this.storage});

  // 2. 状态管理
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 3. UI 控制器
  late TextEditingController userNameController;
  late TextEditingController passwordController;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    passwordController = TextEditingController();

    // 自动填充测试账号
    // userNameController.text = "testuser";
  }

  // 4. 登录逻辑
  Future<void> login() async {
    try {

      final bool isFormValid = formKey.currentState!.validate();

      // (B) (如果校验不通过)
      if (!isFormValid) {
        logger.w("表单校验失败, 请检查输入框下的提示");
        return; // 停止执行
      }

      isLoading(true);
      errorMessage('');

      // A. (核心) 调用 AppRepository 中的 login 方法
      LoginRequest loginRequest = LoginRequest(
        email: userNameController.text,
        password: passwordController.text,
      );

      final token = await appRepo.login(loginRequest);

      // B. 登录成功, 存储 Token
      await storage.writeString('token', token.msg);

      // C. 导航到主页
      Get.offAllNamed(AppRoutes.shell);
    } catch (e) {
      // D. 捕获 Repository 抛出的错误
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/models/login_entity.dart';
import '../../core/models/login_result_entity.dart';
import '../../core/repository/app_repository.dart';
import '../../core/services/app_data_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/api_params_builder.dart';
import '../../routes/app_routes.dart';

class LoginLogic extends GetxController {
  final AppRepository appRepo = Get.find<AppRepository>();
  final AppDataService appData = Get.find<AppDataService>();
  final StorageService storage = Get.find<StorageService>();

  late TextEditingController userNameController;
  late TextEditingController passwordController;

  final formKey = GlobalKey<FormState>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    passwordController = TextEditingController();

    // 自动填充测试账号
    // userNameController.text = "testuser";
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    // 清除上一次的 *UI* 错误
    errorMessage('');

    // (注意) 我们不再需要 try/catch!
    // 因为 Interceptor 会自动显示 Loading 和 Toast
    // (注意) 我们也不再需要 isLoading(true)

    final params = ApiParamsBuilder()
        .username(userNameController.text)
        .password(passwordController.text)
        .build();

    final loginResult = await appRepo.postData<LoginResultEntity>(
      ApiEndpoints.authLogin,
      data: params,
      // (关键)
      // 1. fromJsonT 告诉 Repository 如何解析 'data' 字段
      // 2. T (LoginResultEntity) 会被自动推断出来
      fromJsonT: (json) => LoginResultEntity.fromJson(json as Map<String, dynamic>),
    );

    // (成功)
    // 如果代码执行到这里, 保证 code == 200
    // 'loginResult' 已经是 'LoginResultEntity' (T)
    //todo 恢复
    // await appData.saveLoginEntity(loginResult);
    Get.offAllNamed(AppRoutes.shell);
  }
}

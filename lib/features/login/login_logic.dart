import 'package:dev_lib_getx/core/models/base_response_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/constants/api_config.dart';
import '../../core/models/login_result_entity.dart';
import '../../core/repository/app_network.dart';
import '../../core/services/app_data_service.dart';
import '../../core/services/logger_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/api_params_builder.dart';
import '../../routes/app_routes.dart';

class LoginLogic extends GetxController {
  final AppNetwork appRepo = Get.find<AppNetwork>();
  final AppDataService appData = Get.find<AppDataService>();
  final StorageService storage = Get.find<StorageService>();

  late TextEditingController userNameController;
  late TextEditingController passwordController;

  final formKey = GlobalKey<FormState>();
  var errorMessage = ''.obs;

  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    passwordController = TextEditingController();

    userNameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);

    // 自动填充测试账号
    userNameController.text = "testuser";
  }

  void _validateForm() {
    final user = userNameController.text;
    final pass = passwordController.text;

    // (核心) 4.
    //    在这里实现你的 *完全相同* 的规则
    // 规则 1: 用户名不能为空
    final bool isUserValid = user.isNotEmpty;

    // 规则 2: 密码不能为空, 且 6-10 位
    final bool isPassValid =
        pass.isNotEmpty && pass.length >= 6 && pass.length <= 10;

    // (核心) 5.
    //    *只有* 当所有规则都满足时, 才更新 isFormValid
    isFormValid.value = isUserValid && isPassValid;
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    errorMessage('');

    final params = ApiParamsBuilder()
        .username(userNameController.text)
        .password(passwordController.text)
        .build();

    final loginResult = await appRepo.postData<LoginResultEntity>(
      ApiConfig.authLogin,
      parameter: params,
      fromJsonT: (json) =>
          LoginResultEntity.fromJson(json as Map<String, dynamic>),
    );

    // (成功)
    // 如果代码执行到这里, 保证 code == 200
    // 'loginResult' 已经是 'LoginResultEntity' (T)
    await appData.saveLoginEntity(loginResult);
    Get.offAllNamed(AppRoutes.shell);
  }

  Future<void> loginFull() async {
    // (A) (不变) 1. 客户端表单校验
    if (!formKey.currentState!.validate()) {
      logger.w("表单校验失败, 请检查输入框下的提示");
      return;
    }

    errorMessage('');

    final params = ApiParamsBuilder()
        .username(userNameController.text)
        .password(passwordController.text)
        .build();

    final BaseResponseEntity<LoginResultEntity> response = await appRepo
        .postDataWithFullRes<LoginResultEntity>(
          ApiConfig.authLogin,
          data: params,
          fromJsonT: (json) =>
              LoginResultEntity.fromJson(json as Map<String, dynamic>),
          showToast: true,
        );


    if (response.code == ApiConfig.successCode) {
      if (response.data == null) {
        throw Exception("数据解析失败"); // (这是一个安全兜底)
      }
    } else {
      logger.w(
        "登录业务失败: Code=${response.code}, Msg=${response.msg}, Data=${response.data}",
      );
    }
  }
}

import 'package:dev_lib_getx/core/models/login_full_res_entity.dart';
import 'package:dev_lib_getx/core/models/login_result_entity.dart';
import 'package:dev_lib_getx/core/services/storage_service.dart';
import 'package:get/get.dart';

import 'logger_service.dart';

class AppDataService extends GetxService {
  final StorageService _storage;

  AppDataService({required StorageService storage}) : _storage = storage;

  // (核心)
  // 3. (响应式) 在内存中持有用户状态
  //    使用 Rxn<User>() 意思是“一个可观察的 User, 它可以是 null”
  //    'currentUser' 是 'Rx<User?>' 的简写
  final Rxn<LoginResultEntity> currentUser = Rxn<LoginResultEntity>();

  // (核心)
  // 4. (Getter) 提供一个简单的 'isLoggedIn' 检查器
  //    UI 可以 Obx(() => Get.find<AppDataService>().isLoggedIn) 来切换
  bool get isLoggedIn => currentUser.value != null;

  // (核心)
  // 5. 'init' 方法会在 main.dart 中被调用
  Future<AppDataService> init() async {
    // A. 尝试从磁盘 (StorageService) 读取用户
    final userFromDisk = _storage.getUser(); // (我们上个回复中创建的方法)

    if (userFromDisk != null) {
      // B. 如果磁盘中有, 把它加载到内存 (currentUser.value)
      currentUser.value = userFromDisk;
      logger.i("[AppDataService] 启动：已从磁盘加载用户 $userFromDisk");
    } else {
      logger.i("[AppDataService] 启动：未登录");
    }

    return this;
  }

  // (核心)
  // 6. "登录" 操作
  //    (LoginLogic 会调用这个)
  Future<void> saveLoginEntity(LoginResultEntity user) async {
    // A. 更新内存中的响应式变量
    currentUser.value = user;
    // B. 更新磁盘 (持久化)
    await _storage.saveUser(user);
  }

  // (核心)
  // 7. "退出" 操作
  //    (ProfileLogic 或 SettingsLogic 会调用这个)
  Future<void> signOut() async {
    // A. 清除内存
    currentUser.value = null;

    // B. 清除磁盘
    await _storage.clearAll(); // (或 _storage.clearUser() 等)
  }
}

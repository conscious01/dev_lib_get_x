import 'package:dev_lib_getx/core/models/login_result_entity.dart';
import 'package:dev_lib_getx/core/services/storage_service.dart';
import 'package:get/get.dart';

import 'logger_service.dart';

class AppDataService extends GetxService {
  final StorageService _storage;

  AppDataService({required StorageService storage}) : _storage = storage;

  final Rxn<LoginResultEntity> currentUser = Rxn<LoginResultEntity>();

  bool get isLoggedIn => currentUser.value != null;

  Future<AppDataService> init() async {
    final userFromDisk = _storage.getUser();

    if (userFromDisk != null) {
      currentUser.value = userFromDisk;
      logger.i("[AppDataService] 启动：已从磁盘加载用户 $userFromDisk");
    } else {
      logger.i("[AppDataService] 启动：未登录");
    }

    return this;
  }

  Future<void> saveLoginEntity(LoginResultEntity user) async {
    currentUser.value = user;

    await _storage.saveUser(user);
  }

  Future<void> signOut() async {
    currentUser.value = null;
    await _storage.clearAll();
  }

  var eventData = Rxn<dynamic>();

}

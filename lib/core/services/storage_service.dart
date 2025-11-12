import 'dart:convert';

import 'package:dev_lib_getx/models/login_full_res_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/login_result_entity.dart';
import 'logger_service.dart';

// (核心) 继承 GetxService
// GetxService 不是“响应式”的, 它只是一个普通的 Dart 类
// 但它被 GetX 的依赖注入系统所管理 (Get.put, Get.find)
class StorageService extends GetxService {
  // SharedPreferences 是异步的, 我们用 'late'
  // 来保证它在使用前一定会被 'init()' 方法初始化
  late final SharedPreferences _prefs;

  // (核心) 异步的 'init' 方法
  // 我们会在 main.dart 中使用 Get.putAsync() 来等待它完成
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // --- 封装的读/写方法 ---

  Future<void> writeString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> writeDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> writeInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // 读取数据
  String? readString(String key) {
    return _prefs.getString(key);
  }

  bool? readBool(String key) {
    return _prefs.getBool(key);
  }

  int? readInt(String key) {
    return _prefs.getInt(key);
  }

  double? readDouble(String key) {
    return _prefs.getDouble(key);
  }

  // 检查是否有某个 Key
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  // (核心) 登出时清除所有数据
  Future<void> clearAll() async {
    // (可选) 你可以在这里保留一些数据, 比如 "isFirstOpen"
    await _prefs.clear();
  }

  final _userKey = "userKey";

  Future<void> saveUser(LoginResultEntity user) async {
    try {
      // 1. (序列化) 调用 User 类的 .toJson()
      //    (这是由 json_serializable 生成的)
      final Map<String, dynamic> userMap = user.toJson();

      // 2. (编码) 将 Map 转换为 JSON 字符串
      final String jsonString = jsonEncode(userMap);

      // 3. (保存) 存入 SharedPreferences
      await _prefs.setString(_userKey, jsonString);

      logger.i("[StorageService] User 已保存到本地");
    } catch (e) {
      logger.i("[StorageService] 保存 User 失败: $e");
    }
  }

  /// ✅ (实现) 读取 User 实体类
  /// 从本地读取 JSON 字符串, 并转换为 User 对象
  LoginResultEntity? getUser() {
    try {
      // 1. (读取) 从 SharedPreferences 读取 JSON 字符串
      final String? jsonString = _prefs.getString(_userKey);

      if (jsonString == null) {
        return null; // 没有保存过 User
      }

      // 2. (解码) 将 JSON 字符串转换回 Map
      final Map<String, dynamic> userMap = jsonDecode(jsonString);

      // 3. (反序列化) 调用 User 类的 .fromJson()
      //    (这也是由 json_serializable 生成的)
      final LoginResultEntity user = LoginResultEntity.fromJson(userMap);

      logger.i("[StorageService] 本地 User 读取成功");
      return user;
    } catch (e) {
      logger.i("[StorageService] 读取 User 失败: $e");
      return null;
    }
  }


  static const String _themeKey = "app_theme_mode";
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  ThemeMode readThemeMode() {
    // 1. 尝试读取已保存的 String
    final String? themeName = _prefs.getString(_themeKey);

    // 2. 如果*没有*保存过 (例如 App 第一次启动)
    //    我们就返回 "跟随系统"
    if (themeName == null) {
      return ThemeMode.system;
    }

    // 3. (安全地)
    //    把 String 转换回 ThemeMode.enum
    if (themeName == 'light') {
      return ThemeMode.light;
    }
    if (themeName == 'dark') {
      return ThemeMode.dark;
    }

    // (默认)
    return ThemeMode.system;
  }
}

import 'package:dio/dio.dart';

import '../models/login_entity.dart';
import '../models/login_request.dart';


class AppRepository {

  // (核心) 依赖从构造函数传入
  final Dio _dio;
  AppRepository({required Dio dio}) : _dio = dio;

  // --- 认证 (Auth) 领域 ---

  Future<LoginEntity> login(LoginRequest request) async {
    final response = await _dio.post(
      "https://reqres.in/api/login",
      data: request.toJson(),
    );
    return LoginEntity.fromJson(response.data);
  }

  Future<void> logout() async {
    // ...
  }


}
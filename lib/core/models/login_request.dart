import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart'; // 告诉 build_runner

// (核心)
// reqres.in API 需要的 Body 是:
// {
//    "email": "...",
//    "password": "..."
// }
// 所以我们的实体类也包含这两个字段。

@JsonSerializable()
class LoginRequest {

  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  // (核心)
  // 这个方法会由 build_runner 自动生成
  // 它的作用是把这个 Dart 对象转换成 Map<String, dynamic>
  // 也就是 dio 的 'data:' 参数所需要的格式
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  // (注意)
  // 这是一个“请求”实体, 我们永远不会从 JSON *解析*它
  // (我们只会创建它并*发送*它),
  // 所以理论上你不需要 fromJson，但 json_serializable 默认会一起生成
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}
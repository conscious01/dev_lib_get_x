import 'package:json_annotation/json_annotation.dart';

part 'base_response_entity.g.dart'; // 告诉 build_runner

// (核心)
// 1. (T) 是一个泛型, 代表 'data' 字段的真实类型
// 2. (anyMap: true) 允许 json_serializable 处理 Map
// 3. (genericArgumentFactories: true) 允许它正确地序列化/反序列化 T
@JsonSerializable(anyMap: true, genericArgumentFactories: true)
class BaseResponseEntity<T> {

  // 你的 API 字段
  // (我们假设 code 是 int, msg 是 String)
  final int code;
  final String msg;
  final T? data; // data 字段可能是 null

  BaseResponseEntity({
    required this.code,
    required this.msg,
    this.data,
  });

  // (核心)
  // 这两个方法将由 build_runner 自动生成

  // (注意) fromJson 需要一个额外的参数
  //       来告诉它"如何"解析泛型 T
  factory BaseResponseEntity.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$BaseResponseEntityFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseEntityToJson(this, toJsonT);
}
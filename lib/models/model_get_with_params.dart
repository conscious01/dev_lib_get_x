// To parse this JSON data, do
//
//     final modelGetWithParams = modelGetWithParamsFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'model_get_with_params.freezed.dart';
part 'model_get_with_params.g.dart';

List<ModelGetWithParams> modelGetWithParamsFromJson(String str) => List<ModelGetWithParams>.from(json.decode(str).map((x) => ModelGetWithParams.fromJson(x)));

String modelGetWithParamsToJson(List<ModelGetWithParams> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
abstract class ModelGetWithParams with _$ModelGetWithParams {
  const factory ModelGetWithParams({
    @JsonKey(name: "id")
    required int id,
    @JsonKey(name: "name")
    required String name,
    @JsonKey(name: "category")
    required String category,
  }) = _ModelGetWithParams;

  factory ModelGetWithParams.fromJson(Map<String, dynamic> json) => _$ModelGetWithParamsFromJson(json);
}

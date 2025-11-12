// To parse this JSON data, do
//
//     final modelCombinedStep2 = modelCombinedStep2FromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_combined_step_2.freezed.dart';
part 'model_combined_step_2.g.dart';

ModelCombinedStep2 modelCombinedStep2FromJson(String str) =>
    ModelCombinedStep2.fromJson(json.decode(str));

String modelCombinedStep2ToJson(ModelCombinedStep2 data) =>
    json.encode(data.toJson());

@freezed
abstract class ModelCombinedStep2 with _$ModelCombinedStep2 {
  const factory ModelCombinedStep2({
    @JsonKey(name: "method") required String method,
    @JsonKey(name: "value") required int value,
  }) = _ModelCombinedStep2;

  factory ModelCombinedStep2.fromJson(Map<String, dynamic> json) =>
      _$ModelCombinedStep2FromJson(json);
}

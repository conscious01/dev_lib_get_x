// To parse this JSON data, do
//
//     final modelCombinedStep1 = modelCombinedStep1FromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'model_combined_step_1.freezed.dart';
part 'model_combined_step_1.g.dart';

ModelCombinedStep1 modelCombinedStep1FromJson(String str) => ModelCombinedStep1.fromJson(json.decode(str));

String modelCombinedStep1ToJson(ModelCombinedStep1 data) => json.encode(data.toJson());

@freezed
abstract class ModelCombinedStep1 with _$ModelCombinedStep1 {
  const factory ModelCombinedStep1({
    @JsonKey(name: "method")
    required String method,
    @JsonKey(name: "value")
    required int value,
  }) = _ModelCombinedStep1;

  factory ModelCombinedStep1.fromJson(Map<String, dynamic> json) => _$ModelCombinedStep1FromJson(json);
}

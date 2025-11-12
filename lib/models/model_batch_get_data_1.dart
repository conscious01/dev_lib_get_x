// To parse this JSON data, do
//
//     final modelBatchGetData1 = modelBatchGetData1FromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'model_batch_get_data_1.freezed.dart';
part 'model_batch_get_data_1.g.dart';

ModelBatchGetData1 modelBatchGetData1FromJson(String str) => ModelBatchGetData1.fromJson(json.decode(str));

String modelBatchGetData1ToJson(ModelBatchGetData1 data) => json.encode(data.toJson());

@freezed
abstract class ModelBatchGetData1 with _$ModelBatchGetData1 {
  const factory ModelBatchGetData1({
    @JsonKey(name: "methodGet1")
    required String methodGet1,
    @JsonKey(name: "value")
    required String value,
  }) = _ModelBatchGetData1;

  factory ModelBatchGetData1.fromJson(Map<String, dynamic> json) => _$ModelBatchGetData1FromJson(json);
}

// To parse this JSON data, do
//
//     final modelBatchGetData2 = modelBatchGetData2FromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'model_batch_get_data_2.freezed.dart';
part 'model_batch_get_data_2.g.dart';

ModelBatchGetData2 modelBatchGetData2FromJson(String str) => ModelBatchGetData2.fromJson(json.decode(str));

String modelBatchGetData2ToJson(ModelBatchGetData2 data) => json.encode(data.toJson());

@freezed
abstract class ModelBatchGetData2 with _$ModelBatchGetData2 {
  const factory ModelBatchGetData2({
    @JsonKey(name: "methodGet2")
    required String methodGet2,
    @JsonKey(name: "value")
    required String value,
  }) = _ModelBatchGetData2;

  factory ModelBatchGetData2.fromJson(Map<String, dynamic> json) => _$ModelBatchGetData2FromJson(json);
}

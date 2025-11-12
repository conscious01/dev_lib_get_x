// To parse this JSON data, do
//
//     final modelBatchPostData2 = modelBatchPostData2FromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'model_batch_post_data_2.freezed.dart';
part 'model_batch_post_data_2.g.dart';

ModelBatchPostData2 modelBatchPostData2FromJson(String str) => ModelBatchPostData2.fromJson(json.decode(str));

String modelBatchPostData2ToJson(ModelBatchPostData2 data) => json.encode(data.toJson());

@freezed
abstract class ModelBatchPostData2 with _$ModelBatchPostData2 {
  const factory ModelBatchPostData2({
    @JsonKey(name: "methodPost2")
    required String methodPost2,
    @JsonKey(name: "value")
    required String value,
  }) = _ModelBatchPostData2;

  factory ModelBatchPostData2.fromJson(Map<String, dynamic> json) => _$ModelBatchPostData2FromJson(json);
}

// To parse this JSON data, do
//
//     final modelBatchPostData1 = modelBatchPostData1FromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'model_batch_post_data_1.freezed.dart';
part 'model_batch_post_data_1.g.dart';

ModelBatchPostData1 modelBatchPostData1FromJson(String str) => ModelBatchPostData1.fromJson(json.decode(str));

String modelBatchPostData1ToJson(ModelBatchPostData1 data) => json.encode(data.toJson());

@freezed
abstract class ModelBatchPostData1 with _$ModelBatchPostData1 {
  const factory ModelBatchPostData1({
    @JsonKey(name: "methodPost1")
    required String methodPost1,
    @JsonKey(name: "value")
    required String value,
  }) = _ModelBatchPostData1;

  factory ModelBatchPostData1.fromJson(Map<String, dynamic> json) => _$ModelBatchPostData1FromJson(json);
}

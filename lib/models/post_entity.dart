import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'post_entity.freezed.dart'; // (freezed 会生成这个)
part 'post_entity.g.dart';    // (json_serializable 会生成这个)

// (不变) 
//    你的辅助函数
PostEntity postEntityFromJson(String str) =>
    PostEntity.fromJson(json.decode(str));

String postEntityToJson(PostEntity data) => json.encode(data.toJson());


// (核心修改!)
@freezed
abstract class PostEntity with _$PostEntity {

  // (不变) 
  //    使用 "const factory"
  const factory PostEntity({

    // (不变) 
    //    你的 API 
    //    字段
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "body") required String body,
    @JsonKey(name: "userId") required int userId,

    // (核心) 
    //    (!! 新增 !!) 
    //    你的"本地变量"

    // (A) 
    //    "默认为 false"
    @Default(false)
    // (B) 
    //    "这是本地的, 
    //    JSON 
    //    里没有它"
    @JsonKey(ignore: true)
    bool isLiked,

    // (你还可以添加更多本地变量...)
    // @Default(0) 
    // @JsonKey(ignore: true) 
    // int likeCount,

  }) = _PostEntity;

  // (不变) 
  //    你的 fromJson 
  //    (它会自动忽略 'isLiked')
  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);
}
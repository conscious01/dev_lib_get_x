
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'login_entity.g.dart';

LoginFullResEntity loginEntityFromJson(String str) => LoginFullResEntity.fromJson(json.decode(str));

String loginEntityToJson(LoginFullResEntity data) => json.encode(data.toJson());

@JsonSerializable()
class LoginFullResEntity {
  @JsonKey(name: "code")
  int code;
  @JsonKey(name: "msg")
  String msg;
  @JsonKey(name: "data")
  Data data;

  LoginFullResEntity({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LoginFullResEntity.fromJson(Map<String, dynamic> json) => _$LoginEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginEntityToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "autoUpPosLeastMeters")
  int autoUpPosLeastMeters;
  @JsonKey(name: "ifHiddenOperatorSensitiveInfo")
  int ifHiddenOperatorSensitiveInfo;
  @JsonKey(name: "ifHiddenPledge")
  int ifHiddenPledge;
  @JsonKey(name: "operator")
  Operator dataOperator;
  @JsonKey(name: "parkPlaceMsg")
  List<String> parkPlaceMsg;
  @JsonKey(name: "wxMiniAppCfg")
  WxMiniAppCfg wxMiniAppCfg;

  Data({
    required this.autoUpPosLeastMeters,
    required this.ifHiddenOperatorSensitiveInfo,
    required this.ifHiddenPledge,
    required this.dataOperator,
    required this.parkPlaceMsg,
    required this.wxMiniAppCfg,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Operator {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "areaName")
  String areaName;
  @JsonKey(name: "zoneName")
  String zoneName;

  Operator({
    required this.name,
    required this.areaName,
    required this.zoneName,
  });

  factory Operator.fromJson(Map<String, dynamic> json) => _$OperatorFromJson(json);

  Map<String, dynamic> toJson() => _$OperatorToJson(this);
}

@JsonSerializable()
class WxMiniAppCfg {
  @JsonKey(name: "evasionBackPage")
  String evasionBackPage;
  @JsonKey(name: "parkOutPage")
  String parkOutPage;
  @JsonKey(name: "appId")
  String appId;
  @JsonKey(name: "appSecret")
  String appSecret;
  @JsonKey(name: "ifTurnOn")
  String ifTurnOn;

  WxMiniAppCfg({
    required this.evasionBackPage,
    required this.parkOutPage,
    required this.appId,
    required this.appSecret,
    required this.ifTurnOn,
  });

  factory WxMiniAppCfg.fromJson(Map<String, dynamic> json) => _$WxMiniAppCfgFromJson(json);

  Map<String, dynamic> toJson() => _$WxMiniAppCfgToJson(this);
}

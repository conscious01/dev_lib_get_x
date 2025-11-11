// To parse this JSON data, do
//
//     final loginResultEntity = loginResultEntityFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'login_result_entity.g.dart';

LoginResultEntity loginResultEntityFromJson(String str) => LoginResultEntity.fromJson(json.decode(str));

String loginResultEntityToJson(LoginResultEntity data) => json.encode(data.toJson());

@JsonSerializable()
class LoginResultEntity {


  @JsonKey(name: "autoUpPosLeastMeters")
  int autoUpPosLeastMeters;
  @JsonKey(name: "ifHiddenOperatorSensitiveInfo")
  int ifHiddenOperatorSensitiveInfo;
  @JsonKey(name: "ifHiddenPledge")
  int ifHiddenPledge;
  @JsonKey(name: "operator")
  Operator loginResultEntityOperator;
  @JsonKey(name: "parkPlaceMsg")
  List<String> parkPlaceMsg;
  @JsonKey(name: "wxMiniAppCfg")
  WxMiniAppCfg wxMiniAppCfg;

  LoginResultEntity({
    required this.autoUpPosLeastMeters,
    required this.ifHiddenOperatorSensitiveInfo,
    required this.ifHiddenPledge,
    required this.loginResultEntityOperator,
    required this.parkPlaceMsg,
    required this.wxMiniAppCfg,
  });

  factory LoginResultEntity.fromJson(Map<String, dynamic> json) => _$LoginResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultEntityToJson(this);

  @override
  String toString() {
    return 'LoginResultEntity{autoUpPosLeastMeters: $autoUpPosLeastMeters, ifHiddenOperatorSensitiveInfo: $ifHiddenOperatorSensitiveInfo, ifHiddenPledge: $ifHiddenPledge, loginResultEntityOperator: $loginResultEntityOperator, parkPlaceMsg: $parkPlaceMsg, wxMiniAppCfg: $wxMiniAppCfg}';
  }
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

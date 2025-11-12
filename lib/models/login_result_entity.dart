// To parse this JSON data, do
//
//     final loginResultEntity = loginResultEntityFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_result_entity.freezed.dart';
part 'login_result_entity.g.dart';

LoginResultEntity loginResultEntityFromJson(String str) =>
    LoginResultEntity.fromJson(json.decode(str));

String loginResultEntityToJson(LoginResultEntity data) =>
    json.encode(data.toJson());

@freezed
abstract class LoginResultEntity with _$LoginResultEntity {
  const factory LoginResultEntity({
    @JsonKey(name: "autoUpPosLeastMeters") required int autoUpPosLeastMeters,
    @JsonKey(name: "ifHiddenOperatorSensitiveInfo")
    required int ifHiddenOperatorSensitiveInfo,
    @JsonKey(name: "ifHiddenPledge") required int ifHiddenPledge,
    @JsonKey(name: "operator") required Operator loginResultEntityOperator,
    @JsonKey(name: "parkPlaceMsg") required List<String> parkPlaceMsg,
    @JsonKey(name: "wxMiniAppCfg") required WxMiniAppCfg wxMiniAppCfg,
  }) = _LoginResultEntity;

  factory LoginResultEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginResultEntityFromJson(json);
}

@freezed
abstract class Operator with _$Operator {
  const factory Operator({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "areaName") required String areaName,
    @JsonKey(name: "zoneName") required String zoneName,
  }) = _Operator;

  factory Operator.fromJson(Map<String, dynamic> json) =>
      _$OperatorFromJson(json);
}

@freezed
abstract class WxMiniAppCfg with _$WxMiniAppCfg {
  const factory WxMiniAppCfg({
    @JsonKey(name: "evasionBackPage") required String evasionBackPage,
    @JsonKey(name: "parkOutPage") required String parkOutPage,
    @JsonKey(name: "appId") required String appId,
    @JsonKey(name: "appSecret") required String appSecret,
    @JsonKey(name: "ifTurnOn") required String ifTurnOn,
  }) = _WxMiniAppCfg;

  factory WxMiniAppCfg.fromJson(Map<String, dynamic> json) =>
      _$WxMiniAppCfgFromJson(json);
}

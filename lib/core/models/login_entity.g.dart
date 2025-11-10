// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginEntity _$LoginEntityFromJson(Map<String, dynamic> json) => LoginEntity(
  code: (json['code'] as num).toInt(),
  msg: json['msg'] as String,
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LoginEntityToJson(LoginEntity instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  autoUpPosLeastMeters: (json['autoUpPosLeastMeters'] as num).toInt(),
  ifHiddenOperatorSensitiveInfo: (json['ifHiddenOperatorSensitiveInfo'] as num)
      .toInt(),
  ifHiddenPledge: (json['ifHiddenPledge'] as num).toInt(),
  dataOperator: Operator.fromJson(json['operator'] as Map<String, dynamic>),
  parkPlaceMsg: (json['parkPlaceMsg'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  wxMiniAppCfg: WxMiniAppCfg.fromJson(
    json['wxMiniAppCfg'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'autoUpPosLeastMeters': instance.autoUpPosLeastMeters,
  'ifHiddenOperatorSensitiveInfo': instance.ifHiddenOperatorSensitiveInfo,
  'ifHiddenPledge': instance.ifHiddenPledge,
  'operator': instance.dataOperator,
  'parkPlaceMsg': instance.parkPlaceMsg,
  'wxMiniAppCfg': instance.wxMiniAppCfg,
};

Operator _$OperatorFromJson(Map<String, dynamic> json) => Operator(
  name: json['name'] as String,
  areaName: json['areaName'] as String,
  zoneName: json['zoneName'] as String,
);

Map<String, dynamic> _$OperatorToJson(Operator instance) => <String, dynamic>{
  'name': instance.name,
  'areaName': instance.areaName,
  'zoneName': instance.zoneName,
};

WxMiniAppCfg _$WxMiniAppCfgFromJson(Map<String, dynamic> json) => WxMiniAppCfg(
  evasionBackPage: json['evasionBackPage'] as String,
  parkOutPage: json['parkOutPage'] as String,
  appId: json['appId'] as String,
  appSecret: json['appSecret'] as String,
  ifTurnOn: json['ifTurnOn'] as String,
);

Map<String, dynamic> _$WxMiniAppCfgToJson(WxMiniAppCfg instance) =>
    <String, dynamic>{
      'evasionBackPage': instance.evasionBackPage,
      'parkOutPage': instance.parkOutPage,
      'appId': instance.appId,
      'appSecret': instance.appSecret,
      'ifTurnOn': instance.ifTurnOn,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Historico _$HistoricoFromJson(Map<String, dynamic> json) {
  return Historico(
    json['DESCRICAO'] as String,
    json['QUANTIDADE'] as int,
    json['ACAO'] as String,
    json['DATA'] as String,
  );
}

Map<String, dynamic> _$HistoricoToJson(Historico instance) => <String, dynamic>{
    'DESCRICAO': instance.descricao,
    'QUANTIDADE': instance.quantidade,
    'ACAO': instance.acao,
    'DATA': instance.data,
};

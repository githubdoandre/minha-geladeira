// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Produtos _$ProdutosFromJson(Map<String, dynamic> json) {
  return Produtos(
    json['DESCRICAO'] as String,
    json['QUANTIDADE'] as int,
  );
}

Map<String, dynamic> _$ProdutosToJson(Produtos instance) => <String, dynamic>{
    'DESCRICAO': instance.descricao,
    'QUANTIDADE': instance.quantidade,
};

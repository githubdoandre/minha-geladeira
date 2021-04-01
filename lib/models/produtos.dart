import 'package:json_annotation/json_annotation.dart';

part 'produtos.g.dart';

@JsonSerializable()
class Produtos {
  @JsonKey(name: 'DESCRICAO')
  String descricao;
  @JsonKey(name: 'QUANTIDADE')
  int quantidade;

  Produtos(this.descricao, this.quantidade);

  factory Produtos.fromJson(Map<String, dynamic> json) =>
      _$ProdutosFromJson(json);
  Map<String, dynamic> toJson() => _$ProdutosToJson(this);
}

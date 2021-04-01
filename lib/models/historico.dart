import 'package:json_annotation/json_annotation.dart';

part 'historico.g.dart';

@JsonSerializable()
class Historico {
  @JsonKey(name: 'DESCRICAO')
  String descricao;
  @JsonKey(name: 'QUANTIDADE')
  int quantidade;
  @JsonKey(name: 'AÇÃO')
  String acao;
  @JsonKey(name: 'DATA')
  String data;

  Historico(this.descricao, this.quantidade, this.acao, this.data);

  factory Historico.fromJson(Map<String, dynamic> json) =>
      _$HistoricoFromJson(json);
  Map<String, dynamic> toJson() => _$HistoricoToJson(this);
}

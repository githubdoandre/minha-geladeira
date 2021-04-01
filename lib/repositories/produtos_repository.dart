import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geladeira/models/produtos.dart';
import 'package:geladeira/repositories/historico_repository.dart';
import 'package:intl/intl.dart';

class ProdutosRepository {
  static const String COLLECTION = 'produtos';
  final HistoricoRepository historicoRepository = HistoricoRepository();

  Future<List<Produtos>> getList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(COLLECTION)
        .orderBy('DESCRICAO', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => Produtos.fromJson(doc.data.call()))
        .toList();
  }

  Future<void> insert(String descricao, int quantidade) async {
    Map<String, dynamic> data = {'DESCRICAO': descricao};

    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(COLLECTION)
        .where('DESCRICAO', isEqualTo: descricao)
        .get();

    if (snapshots.docs.length == 0) {
      data['QUANTIDADE'] = quantidade;

      FirebaseFirestore.instance
          .collection(COLLECTION)
          .doc("produto_$descricao")
            ..set(data);
    } else {
      Produtos produto = Produtos.fromJson(snapshots.docs.first.data());
      produto.quantidade += quantidade;
      snapshots.docs.first.reference.update(produto.toJson());
    }

    historicoRepository.insert({
      'DESCRICAO': descricao,
      'QUANTIDADE': quantidade,
      'ACAO': 'ADICAO',
      'DATA': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
    });
  }

  Future<void> update(Produtos produto, int quantidade) async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection(COLLECTION)
        .where('DESCRICAO', isEqualTo: produto.descricao)
        .get();

    if (produto.quantidade == quantidade) {
      snapshots.docs.first.reference.delete();
    } else {
      produto.quantidade -= quantidade;
      snapshots.docs.first.reference.update(produto.toJson());
    }

    historicoRepository.insert({
      'DESCRICAO': produto.descricao,
      'QUANTIDADE': quantidade,
      'ACAO': 'CONSUMO',
      'DATA': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
    });
  }
}

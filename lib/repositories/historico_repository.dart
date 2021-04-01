import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geladeira/models/historico.dart';
import 'dart:math';

class HistoricoRepository {
  static const String COLLECTION = 'historico';

  Future<List<Historico>> getList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(COLLECTION)
        .orderBy('DATA', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Historico.fromJson(doc.data.call()))
        .toList();
  }

  Future<List<Historico>> getListConsumo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(COLLECTION)
        .where('ACAO', isEqualTo: 'CONSUMO')
        .orderBy('DATA', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Historico.fromJson(doc.data.call()))
        .toList();
  }

  Future<void> insert(Map<String, dynamic> data) async {
    var rng = new Random();

    FirebaseFirestore.instance
        .collection(COLLECTION)
        .doc("historico_${data['DESCRICAO']}_${rng.nextInt(9999)}")
          ..set(data);
  }
}

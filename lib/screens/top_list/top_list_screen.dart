import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geladeira/components/menu.dart';
import 'package:geladeira/models/historico.dart';
import 'package:geladeira/repositories/historico_repository.dart';
import 'package:geladeira/screens/historico/historico_bloc.dart';
import 'dart:collection';

class Result {
  String descricao;
  int quantidade;

  Result(this.descricao, this.quantidade);
}

class TopListScreen extends StatefulWidget {
  const TopListScreen({Key key}) : super(key: key);

  @override
  _TopListScreenState createState() => _TopListScreenState();
}

class _TopListScreenState extends State<TopListScreen> {
  final HistoricoBloc _bloc = HistoricoBloc(HistoricoRepository());
  TabController _tabController;

  @override
  void initState() {
    _bloc.fecthListConsumo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text('Top 5 mais consumidos'),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder<List<Historico>>(
            stream: _bloc.historicoListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.data.length == 0) {
                return Center(
                  child: Text('Nenhum registro no momento'),
                );
              }

              var result = getSum(snapshot);

              return ListView.separated(
                padding: EdgeInsets.all(6),
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => ListTile(
                  title: Text("${index + 1} - ${result[index].descricao}"),
                  trailing:
                      Text("${result[index].quantidade.toString()} UN"),
                ),
                shrinkWrap: true,
                itemCount: result.length,
              );
            },
          ),
        ),
      ),
    );
  }

  List<Result> getSum(snapshot) {
    var list = snapshot.data;
    List<String> produtos = [];

    List<String>.from(list.map(
      (item) {
        if (!produtos.contains(item.descricao)) produtos.add(item.descricao);
      },
    ));

    Map<String, dynamic> sum = {};

    int qte = 0;
    produtos.forEach((p) {
      qte = 0;
      list.forEach((element) {
        if (element.descricao == p) {
          qte += element.quantidade;
          sum[element.descricao] = qte;
        }
      });
    });

    var sortedKeys = sum.keys.toList(growable: false)
      ..sort((k1, k2) => sum[k2].compareTo(sum[k1]));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => sum[k]);

    List<Result> results = sortedMap.entries
        .map((entry) => Result(entry.key, entry.value))
        .toList();

    return results.sublist(0, results.length < 5 ? results.length : 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

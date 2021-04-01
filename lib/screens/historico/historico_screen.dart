import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geladeira/components/menu.dart';
import 'package:geladeira/models/historico.dart';
import 'package:geladeira/repositories/historico_repository.dart';
import 'package:geladeira/screens/historico/historico_bloc.dart';
import 'package:intl/intl.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({Key key}) : super(key: key);

  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen>
    with SingleTickerProviderStateMixin {
  final HistoricoBloc _bloc = HistoricoBloc(HistoricoRepository());
  TabController _tabController;

  @override
  void initState() {
    _bloc.fecthList();
    _tabController = TabController(vsync: this, length: 2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text('Histórico'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Adições",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Consumo",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    adicoes(),
                    consumos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget adicoes() {
    return StreamBuilder<List<Historico>>(
      stream: _bloc.historicoListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } 

        List<Historico> adicoesList =
            snapshot.data.where((element) => element.acao == 'ADICAO').toList();

        if (adicoesList.length == 0) {
          return Center(
            child: Text('Nenhum registro de adição'),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(6),
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) => ListTile(
            title: Text(snapshot.data[index].descricao),
            subtitle: Text("${snapshot.data[index].quantidade.toString()} UN"),
            trailing: Text(DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(DateTime.parse(snapshot.data[index].data))),
          ),
          shrinkWrap: true,
          itemCount: adicoesList.length,
        );
      },
    );
  }

   Widget consumos() {
    return StreamBuilder<List<Historico>>(
      stream: _bloc.historicoListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } 

        List<Historico> adicoesList =
            snapshot.data.where((element) => element.acao == 'CONSUMO').toList();

        if (adicoesList.length == 0) {
          return Center(
            child: Text('Nenhum registro de consumo'),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(6),
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) => ListTile(
            title: Text(snapshot.data[index].descricao),
            subtitle: Text("${snapshot.data[index].quantidade.toString()} UN"),
            trailing: Text(DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(DateTime.parse(snapshot.data[index].data))),
          ),
          shrinkWrap: true,
          itemCount: adicoesList.length,
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:geladeira/models/historico.dart';
import 'package:geladeira/models/produtos.dart';
import 'package:geladeira/repositories/historico_repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoricoBloc extends BlocBase {
  final HistoricoRepository repository;

  final _listController = BehaviorSubject<List<Historico>>();
  Stream get historicoListStream => _listController.stream;

  List<Historico> _produtosList;

  HistoricoBloc(this.repository);

  Future<void> fecthList() async {
    _produtosList = await repository.getList();
    _listController.sink.add(_produtosList);
  }

  Future<void> fecthListConsumo() async {
    _produtosList = await repository.getListConsumo();
    _listController.sink.add(_produtosList);
  }

  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}

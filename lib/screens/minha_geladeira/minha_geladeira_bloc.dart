import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:geladeira/models/produtos.dart';
import 'package:geladeira/repositories/produtos_repository.dart';
import 'package:rxdart/rxdart.dart';

class MinhaGeladeiraBloc extends BlocBase {
  final ProdutosRepository repository;

  final _listController = BehaviorSubject<List<Produtos>>();
  Stream get produtosListStream => _listController.stream;

  List<Produtos> _produtosList;

  MinhaGeladeiraBloc(this.repository);

  Future<void> fecthList() async {
    _produtosList = await repository.getList();
    _listController.sink.add(_produtosList);
  }

  Future<void> insert(String descricao, int quantidade) async {
    await repository.insert(descricao, quantidade);
    fecthList();
  }

  Future<void> update(Produtos produto, int quantidade) async {
    await repository.update(produto, quantidade);
    fecthList();
  }

  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:geladeira/components/menu.dart';
import 'package:geladeira/models/produtos.dart';
import 'package:geladeira/repositories/produtos_repository.dart';
import 'package:geladeira/screens/minha_geladeira/minha_geladeira_bloc.dart';

class MinhaGeladeiraScreen extends StatefulWidget {
  MinhaGeladeiraScreen({Key key}) : super(key: key);
  @override
  _MinhaGeladeiraScreenState createState() => _MinhaGeladeiraScreenState();
}

class _MinhaGeladeiraScreenState extends State<MinhaGeladeiraScreen> {
  final _descricaoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _quantidadeConsumirController = TextEditingController();
  final MinhaGeladeiraBloc _bloc = MinhaGeladeiraBloc(ProdutosRepository());
  final _formKey = GlobalKey<FormState>();
  final _formConsumirKey = GlobalKey<FormState>();

  @override
  void initState() {
    _bloc.fecthList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Adicionar item',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Informe a descrição.';
                            }
                            return null;
                          },
                          controller: _descricaoController,
                          maxLines: null,
                          decoration: InputDecoration(
                            prefixIcon: SizedBox(
                              width: 64,
                              child: Center(
                                child: Icon(Icons.content_paste),
                              ),
                            ),
                            suffix: SizedBox(
                              width: 64,
                            ),
                            hintText: "Descrição",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Color.fromRGBO(25, 48, 70, 1),
                          ),
                          onChanged: (v) {},
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Informe a quantidade.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: _quantidadeController,
                              maxLines: null,
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 64,
                                  child: Center(
                                    child: Icon(Icons.content_paste),
                                  ),
                                ),
                                suffix: SizedBox(
                                  width: 64,
                                ),
                                hintText: "Quantidade",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Color.fromRGBO(25, 48, 70, 1),
                              ),
                              onChanged: (v) {},
                            ),
                            TextButton(
                              child: Text('Gravar'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  await _bloc.insert(_descricaoController.text,
                                      int.parse(_quantidadeController.text));

                                  _bloc.fecthList();

                                  _descricaoController.text = '';
                                  _quantidadeController.text = '';

                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Minha Geladeira'),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder<List<Produtos>>(
            stream: _bloc.produtosListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.data.length == 0) {
                return Center(
                  key: Key('produto-zero-data-message'),
                  child: Text('Nenhum produto no momento'),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    snapshot.data[index].descricao,
                  ),
                  subtitle: Text(
                    "${snapshot.data[index].quantidade.toString()} UN",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      return showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Consumir item',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Form(
                                      key: _formConsumirKey,
                                      child: TextFormField(
                                        validator: (text) {
                                          if (text == null ||
                                              text.isEmpty ||
                                              text == '0') {
                                            return 'Informe a quantidade.';
                                          }
                                          if (snapshot.data[index].quantidade <
                                              int.parse(text)) {
                                            return 'Quantidade insuficiente';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        controller:
                                            _quantidadeConsumirController,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                            width: 64,
                                            child: Center(
                                              child: Icon(Icons.content_paste),
                                            ),
                                          ),
                                          suffix: SizedBox(
                                            width: 64,
                                          ),
                                          hintText: "Quantidade",
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Color.fromRGBO(25, 48, 70, 1),
                                        ),
                                        onChanged: (v) {},
                                      ),
                                    ),
                                    TextButton(
                                      child: Text('Gravar'),
                                      onPressed: () async {
                                        if (_formConsumirKey.currentState
                                            .validate()) {
                                          await _bloc.update(
                                              snapshot.data[index],
                                              int.parse(
                                                  _quantidadeConsumirController
                                                      .text));

                                          _bloc.fecthList();
                                          _quantidadeConsumirController.text =
                                              '';

                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

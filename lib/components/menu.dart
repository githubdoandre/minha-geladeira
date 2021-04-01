import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  Menu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Usuário de testes'),
            accountEmail: Text('user@user.com'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Minha Geladeira'),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          ListTile(
            title: Text('Histórico'),
            onTap: () => Navigator.pushNamed(context, '/historico'),
          ),
          ListTile(
            title: Text('Top 5'),
            onTap: () => Navigator.pushNamed(context, '/topList'),
          ),
        ],
      ),
    );
  }
}

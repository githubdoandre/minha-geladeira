import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geladeira/screens/historico/historico_screen.dart';
import 'package:geladeira/screens/minha_geladeira/minha_geladeira_screen.dart';
import 'package:geladeira/screens/top_list/top_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRoute,
      title: 'Minha geladeira',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MinhaGeladeiraScreen(),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => MinhaGeladeiraScreen(),
        );
      case '/historico':
        return MaterialPageRoute(
          builder: (_) => HistoricoScreen(),
        );
      case '/topList':
        return MaterialPageRoute(
          builder: (_) => TopListScreen(),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/relatorio_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/relatorio': (context) => RelatorioPage(),
    },
  ));
}
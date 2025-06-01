import 'package:flutter/material.dart';
import '../utils/relatorio_generator.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerar Relatório')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await gerarRelatorioPDF();
          },
          child: const Text('Gerar Relatório PDF'),
        ),
      ),
    );
  }
}

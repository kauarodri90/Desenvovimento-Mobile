import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> gerarRelatorioPDF() async {
  final pdf = pw.Document();

  final data = [
    {'nome': 'Usuário 1', 'quantidade': 5},
    {'nome': 'Usuário 2', 'quantidade': 3},
    {'nome': 'Usuário 3', 'quantidade': 8},
  ];


  final imageData = await rootBundle.load('assets/grafico.png');
  final image = pw.MemoryImage(imageData.buffer.asUint8List());

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text('Relatório de Usuários', style: pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ['Nome', 'Quantidade'],
          data: data.map((e) => [e['nome'], e['quantidade'].toString()]).toList(),
        ),
        pw.SizedBox(height: 20),
        pw.Text('Gráfico:'),
        pw.SizedBox(height: 10),
        pw.Image(image),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

// =======================================================
// CÓDIGO COMENTADO USANDO charts_flutter (por não rodar)
// =======================================================

// import 'package:charts_flutter/flutter.dart' as charts;
// class UsuarioData {
//   final String nome;
//   final int quantidade;
//   UsuarioData(this.nome, this.quantidade);
// }
//
// Widget graficoComChartsFlutter() {
//   final data = [
//     UsuarioData('Usuário 1', 5),
//     UsuarioData('Usuário 2', 3),
//     UsuarioData('Usuário 3', 8),
//   ];
//
//   final series = [
//     charts.Series<UsuarioData, String>(
//       id: 'Usuarios',
//       domainFn: (UsuarioData u, _) => u.nome,
//       measureFn: (UsuarioData u, _) => u.quantidade,
//       data: data,
//     )
//   ];
//
//   return charts.BarChart(series, animate: true);
// }

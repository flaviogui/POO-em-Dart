import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.red,
      textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color.fromARGB(255, 3, 91, 6))),
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          "CERVEJAS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Nome'),
            ),
            DataColumn(
              label: Text('Estilo'),
            ),
            DataColumn(
              label: Text('BIU'),
            ),
            DataColumn(
              label: Text('Teor alcoólico'),
            ),
            DataColumn(
              label: Text('Volume líquido'),
            ),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('La Fin Du Monde')),
              DataCell(Text('Bock')),
              DataCell(Text('65')),
              DataCell(Text('9%')),
              DataCell(Text('750 ml')),
            ]),
            DataRow(cells: [
              DataCell(Text('Sapporo Premium')),
              DataCell(Text('Sour Ale')),
              DataCell(Text('54')),
              DataCell(Text('4.9%')),
              DataCell(Text('650 ml')),
            ]),
            DataRow(cells: [
              DataCell(Text('Duvel')),
              DataCell(Text('Plisner')),
              DataCell(Text('82')),
              DataCell(Text('8,5%')),
              DataCell(Text('330ml')),
            ]),
            DataRow(cells: [
              DataCell(Text('Budweiser')),
              DataCell(Text('American lager')),
              DataCell(Text('10')),
              DataCell(Text('5,0%')),
              DataCell(Text('330ml')),
            ]),
            DataRow(cells: [
              DataCell(Text('Budweiser')),
              DataCell(Text('American lager')),
              DataCell(Text('10')),
              DataCell(Text('5,0%')),
              DataCell(Text('330ml')),
            ]),
            DataRow(cells: [
              DataCell(Text('Heineken')),
              DataCell(Text('International Pale Lager')),
              DataCell(Text('23')),
              DataCell(Text('Holanda')),
              DataCell(Text('4,5% de álcool')),
            ]),
          ],
        ),
      ),
    ),
  );
  runApp(app);
}

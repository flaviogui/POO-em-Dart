import 'package:flutter/material.dart';

void main() {
  MeuNovoApp app = MeuNovoApp();

  runApp(app);
}

var dataObjectos = [
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "Budweiser", "style": "American lager", "ibu": "10"},
  {"name": "Heineken", "style": "International Pale Lager", "ibu": "23"},
  {"name": "Corona Extra", "style": "American Lager", "ibu": "19"},
  {"name": "Guinnes Draft", "style": "Rost", "ibu": "45"},
  {"name": "Hefeweizen", "style": "Weissbier", "ibu": "15"},
  {"name": "Pilsner", "style": "Pilsner", "ibu": "45"},
  {"name": "Stella", "style": "Premium Lager", "ibu": "16"},
  {"name": "Skol Puro Malte", "style": "Premium Lager", "ibu": "11"},
];

class MyApp extends StatelessWidget {
  get dataObjects => dataObjectos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Dicas"),
          ),
          body: Center(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataBodyWidget(
                      objects: dataObjects,
                      propertyNames: ["name", "style", "ibu"],
                      columnNames: ["NOME", "ESTILO", "IBU"]))),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class NewNavBar extends StatelessWidget {
  NewNavBar();

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: botaoFoiTocado, items: const [
      BottomNavigationBarItem(
        label: "Cafés",
        icon: Icon(Icons.coffee_outlined),
      ),
      BottomNavigationBarItem(
          label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
      BottomNavigationBarItem(label: "Nações", icon: Icon(Icons.flag_outlined))
    ]);
  }
}

class DataBodyWidget extends StatelessWidget {
  List objects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataBodyWidget(
      {this.objects = const [],
      this.columnNames = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: objects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}

class MytileWidget extends StatelessWidget {
  List objects;
  final List<String> columnNames;
  final List<String> propertyNames;

  MytileWidget(
      {this.objects = const [],
      this.columnNames = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: objects.length,
      itemBuilder: (context, index) {
        final obj = objects[index];

        final columnTexts = columnNames.map((col) {
          final prop = propertyNames[columnNames.indexOf(col)];
          return Text("$col: ${obj[prop]}");
        }).toList();

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnTexts,
          ),
        );
      },
    );
  }
}

class MeuNovoApp extends StatelessWidget {
  get dataObjects => dataObjectos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Dicas"),
          ),
          body: Center(
              child: MytileWidget(
                  objects: dataObjects,
                  propertyNames: ["name", "style", "ibu"],
                  columnNames: ["NOME", "ESTILO", "IBU"])),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

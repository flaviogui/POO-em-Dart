import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class DataService {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);
  var coluna = ["Nome", "Estilo", "IBU"];
  var chave = ["name", "style", "ibu"];
  int selectedQuantity = 10;
  int index = 0;

  Future<void> carregarCervejas() async {
    colunaCerveja();

    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/beer/random_beer',
      queryParameters: {'size': selectedQuantity.toString()},
    );

    var jsonString = await http.read(beersUri);
    var beersJson = jsonDecode(jsonString);
    tableStateNotifier.value = beersJson;
  }

  Future<void> carregarCafe() async {
    colunaCafe();

    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/coffee/random_coffee',
      queryParameters: {'size': selectedQuantity.toString()},
    );

    var jsonString = await http.read(beersUri);
    var beersJson = jsonDecode(jsonString);
    tableStateNotifier.value = beersJson;
  }

  Future<void> carregarNacoes() async {
    colunaNacao();

    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/nation/random_nation',
      queryParameters: {'size': selectedQuantity.toString()},
    );

    var jsonString = await http.read(beersUri);
    var beersJson = jsonDecode(jsonString);
    tableStateNotifier.value = beersJson;
  }

  void carregar(int index) {
    var res = null;
    if (index == 1) {
      res = carregarCervejas();
    } else if (index == 0) {
      res = carregarCafe();
    } else if (index == 2) {
      carregarNacoes();
    } else {
      tableStateNotifier.value = [];
    }
  }

  void colunaCerveja() {
    chave = ["name", "style", "ibu"];
    coluna = ["Nome", "Estilo", "IBU"];
  }

  void colunaCafe() {
    chave = ["blend_name", "origin", "uid"];
    coluna = ["Nome", "Origem", "UID"];
  }

  void colunaNacao() {
    chave = ["nationality", "language", "capital"];
    coluna = ["Nome", "Língua", "Capital"];
  }
}

final dataService = DataService();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("DICAS"),
          actions: [
            PopupMenuButton<int>(
              icon: Icon(Icons.filter_list),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 5,
                  child: Text("5 itens"),
                ),
                PopupMenuItem(
                  value: 10,
                  child: Text("10 itens"),
                ),
                PopupMenuItem(
                  value: 15,
                  child: Text("15 itens"),
                ),
              ],
              onSelected: (value) {
                dataService.selectedQuantity = value;
                dataService.carregar(dataService.index);
              },
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            return DataTableWidget(
              jsonObjects: value,
              propertyNames: dataService.chave,
              columnNames: dataService.coluna,
            );
          },
        ),
        bottomNavigationBar:
            NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Cafés",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const ["Nome", "Estilo", "IBU"],
      this.propertyNames = const ["name", "style", "ibu"]});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}

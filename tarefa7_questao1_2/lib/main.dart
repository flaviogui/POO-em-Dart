import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class DataService {
  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);
  var coluna = ["Nome", "Estilo", "IBU"];
  var chave = ["name", "style", "ibu"];

  Future<void> carregarCervejas() async {
    colunaCerveja();
    //1

    var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '5'});
    //2
    var jsonString = await http.read(beersUri);
    //3
    var beersJson = jsonDecode(jsonString);
    //4
    tableStateNotifier.value = beersJson;
  }

  void carregarCafe() {
    colunaCafe();
    tableStateNotifier.value = [
      {
        "name": "Pilão",
        "origem": "Itália",
        "composicao": "Café torrado e moído"
      },
      {
        "name": "3 corações",
        "origem": "Minas Gerais / BR",
        "composicao": "Café em grão torrado e moído."
      },
      {
        "name": "Baggio",
        "origem": "Brasil",
        "composicao": "100% coffea arabica"
      }
    ];
  }

  void carregarNacoes() {
    colunaNacao();
    tableStateNotifier.value = [
      {
        "name": "Brasil",
        "habitantes": "214,3 milhões",
        "area": "8.510.000 km²"
      },
      {"name": "China", "habitantes": "1,412 bilhão ", "area": "9.597.000 km²"},
      {
        "name": "Estados Unidos",
        "habitantes": "331,9 milhões",
        "area": "9.834.000 km²"
      }
    ];
  }

  void carregar(int index) {
    if (index == 1) {
      carregarCervejas();
    } else if (index == 0) {
      carregarCafe();
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
    chave = ["name", "origem", "composicao"];
    coluna = ["Nome", "Origem", "Ingredientes"];
  }

  void colunaNacao() {
    chave = ["name", "habitantes", "area"];
    coluna = ["Nome", "Habitantes", "Área"];
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
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return DataTableWidget(
                  jsonObjects: value,
                  propertyNames: dataService.chave,
                  columnNames: dataService.coluna,
                );
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
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

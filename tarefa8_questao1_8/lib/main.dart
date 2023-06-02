import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  MyApp app = MyApp();

  runApp(app);
}

enum TableStatus { idle, loading, ready, error }

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});

  void carregar(index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': []
    };

    funcoes[index]();
  }

  void carregarCafes() {
    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/coffee/random_coffee',
      queryParameters: {'size': '10'},
    );

    http.read(beersUri).then((jsonString) {
      var beersJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'propertyNames': ["blend_name", "origin", "uid"],
        'columnNames': ["Nome", "Origem", "UID"],
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
      };
      print('$error');
    });
  }

  Future<void> carregarNacoes() async {
    try {
      var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/nation/random_nation',
        queryParameters: {'size': '10'},
      );

      var jsonString = await http.read(beersUri);
      var beersJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'propertyNames': ["nationality", "language", "capital"],
        'columnNames': ["Nome", "Língua", "Capital"],
      };
    } catch (error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
      };
      print('$error');
    }
  }

  void carregarCervejas() {
    var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '10'});

    http.read(beersUri).then((jsonString) {
      var beersJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'propertyNames': ["name", "style", "ibu"],
        'columnNames': ["Nome", "Origem", "UID"],
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
      };
      print('$error');
    });
  }
}

final dataService = DataService();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("DICAS E INFORMAÇÕES"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                switch (value['status']) {
                  case TableStatus.idle:
                    return const Center(
                      child: Text(
                        "Clique em um desses 3 botões",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    );

                  case TableStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case TableStatus.ready:
                    return DataTableWidget(
                        jsonObjects: value['dataObjects'],
                        propertyNames: value['propertyNames'],
                        columnNames: value['columnNames']);
                  case TableStatus.error:
                    return const Center(
                        child: Text(
                            'Erro ao carregar... Por favor, verificar sua conexão com a internet!',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)));
                }

                return Text("...");
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;

          _itemSelectedCallback(index);
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

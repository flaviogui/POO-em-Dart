import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum TableStatus { idle, loading, ready, error }

enum ItemType {
  appliances,
  banks,
  addresses,
  none;

  String get asString => '$name';
  List<String> get columns => this == appliances
      ? ["Equipamento", "Marca", "UID"]
      : this == banks
          ? ["Nome do Banco", "Nº da conta", "SWIFT"]
          : this == addresses
              ? ["Cidade", "Rua", "CEP"]
              : [];
  List<String> get properties => this == appliances
      ? ["equipment", "brand", "uid"]
      : this == banks
          ? ["bank_name", "account_number", "swift_bic"]
          : this == addresses
              ? ["city", "street_name", "zip_code"]
              : [];
}

class DataService {
  static const MAX_N_ITEMS = 15;
  static const MIN_N_ITEMS = 3;
  static const DEFAULT_N_ITEMS = 7;

  int _numberOfItems = DEFAULT_N_ITEMS;
  List<int> _possibleNItems = [MIN_N_ITEMS, DEFAULT_N_ITEMS, MAX_N_ITEMS];

  int get numberOfItems {
    return _numberOfItems;
  }

  set numberOfItems(int n) {
    _numberOfItems = n < 0
        ? MIN_N_ITEMS
        : n > MAX_N_ITEMS
            ? MAX_N_ITEMS
            : n;
  }

  List<int> get possibleNItems {
    return _possibleNItems;
  }

  set possibleNItems(List<int> n) {
    _possibleNItems = n;
  }

  ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none,
  });

  void carregar(int index) {
    final params = [ItemType.appliances, ItemType.banks, ItemType.addresses];
    carregarPorTipo(params[index]);
  }

  void ordenarEstadoAtual(String propriedade, bool ascending) {
    List<dynamic> objetos = tableStateNotifier.value['dataObjects'] ?? [];
    if (objetos.isEmpty) return;

    objetos.sort((a, b) {
      var valorA = a[propriedade];
      var valorB = b[propriedade];
      if (valorA is String && valorB is String) {
        return ascending ? valorA.compareTo(valorB) : valorB.compareTo(valorA);
      } else if (valorA is num && valorB is num) {
        return ascending ? valorA.compareTo(valorB) : valorB.compareTo(valorA);
      } else {
        return 0;
      }
    });

    emitirEstadoOrdenado(objetos, propriedade, ascending);
  }

  List<dynamic> filtarObjetos() {
    String filtro = tableStateNotifier.value['filterCriteria'];
    List<dynamic> objetos = tableStateNotifier.value['dataObjects'] ?? [];
    if (objetos.isEmpty) return [];

    List<dynamic> objetosFiltrados = objetos.where((objeto) {
      var propriedades = objeto.values.toList();
      for (var propriedade in propriedades) {
        if (propriedade is String && propriedade.contains(filtro)) {
          return true;
        }
      }
      return false;
    }).toList();

    return objetosFiltrados;
  }

  Uri montarUri(ItemType type) {
    return Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/v2/${type.asString}',
      queryParameters: {'size': '$_numberOfItems'},
    );
  }

  Future<List<dynamic>> acessarApi(Uri uri) async {
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Erro ao acessar a API');
    }
  }

  void emitirEstadoOrdenado(
    List<dynamic> objetosOrdenados,
    String propriedade,
    bool ascending,
  ) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['dataObjects'] = objetosOrdenados;
    estado['sortCriteria'] = propriedade;
    estado['ascending'] = ascending;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoFiltrado(String filtro) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['filterCriteria'] = filtro;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoCarregando(ItemType type) {
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'itemType': type,
      'filterCriteria': '',
    };
  }

  void emitirEstadoPronto(ItemType type, List<dynamic> json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'columnNames': type.columns,
      'filterCriteria': '',
    };
  }

  bool temRequisicaoEmCurso() =>
      tableStateNotifier.value['status'] == TableStatus.loading;
  bool mudouTipoDeItemRequisitado(ItemType type) =>
      tableStateNotifier.value['itemType'] != type;

  void carregarPorTipo(ItemType type) async {
    if (temRequisicaoEmCurso()) return;
    if (mudouTipoDeItemRequisitado(type)) {
      emitirEstadoCarregando(type);
    }
    var uri = montarUri(type);
    try {
      var json = await acessarApi(uri);
      emitirEstadoPronto(type, json);
    } catch (e) {
      emitirEstadoOrdenado([], '', true);
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'itemType': type,
        'filterCriteria': '',
      };
    }
  }
}

final dataService = DataService();

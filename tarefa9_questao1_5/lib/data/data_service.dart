import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum TableStatus { idle, loading, ready, error }

enum ItemType { beer, coffee, nation, none }

class ConfigMenu {
  static const List<int> itemQuantidades = [3, 5, 7];
}

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none
  });

  static const MAX_N_ITEMS = 15;
  static const MIN_N_ITEMS = 3;
  static const DEFAULT_N_ITEMS = 7;

  int _numberOfItems = DEFAULT_N_ITEMS;

  set numberOfItems(n) {
    _numberOfItems = n < 0
        ? MIN_N_ITEMS
        : n > MAX_N_ITEMS
            ? MAX_N_ITEMS
            : n;
  }

  int get numberOfItens {
    return _numberOfItems;
  }

  void carregar(index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];

    funcoes[index]();
  }

  void carregarCafes() {
    _carregarItens(ItemType.coffee, 'api/coffee/random_coffee',
        ['blend_name', 'origin', 'variety']);
  }

  void carregarNacoes() {
    _carregarItens(ItemType.nation, 'api/nation/random_nation',
        ['nationality', 'capital', 'language', 'national_sport']);
  }

  void carregarCervejas() {
    _carregarItens(
        ItemType.beer, 'api/beer/random_beer', ['name', 'style', 'ibu']);
  }

  void _carregarItens(
      ItemType itemType, String path, List<String> propertyNames) {
    if (tableStateNotifier.value['status'] == TableStatus.loading) return;
    if (tableStateNotifier.value['itemType'] != itemType) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': itemType,
      };
    }

    var uri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: path,
      queryParameters: {'size': '$_numberOfItems'},
    );
    http.read(uri).then((jsonString) {
      var itemsJson = jsonDecode(jsonString);

      if (tableStateNotifier.value['status'] != TableStatus.loading) {
        itemsJson = [...tableStateNotifier.value['dataObjects'], ...itemsJson];
      }
      tableStateNotifier.value = {
        'itemType': itemType,
        'status': TableStatus.ready,
        'dataObjects': itemsJson,
        'propertyNames': propertyNames,
        'columnNames': propertyNames,
        'itemCount': itemsJson.length,
      };
    });
  }
}

final dataService = DataService();

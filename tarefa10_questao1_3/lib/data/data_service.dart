import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/ordenador.dart';
import '../util/filto.dart';

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
  List _possibleNItems = [MIN_N_ITEMS, DEFAULT_N_ITEMS, MAX_N_ITEMS];

  int get numberOfItems {
    return _numberOfItems;
  }

  set numberOfItems(n) {
    _numberOfItems = n < 0
        ? MIN_N_ITEMS
        : n > MAX_N_ITEMS
            ? MAX_N_ITEMS
            : n;
  }

  List get possibleNItems {
    return _possibleNItems;
  }

  set possibleNItems(n) {
    _possibleNItems = possibleNItems;
  }

  ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none
  });

  void carregar(index) {
    final params = [ItemType.appliances, ItemType.banks, ItemType.addresses];
    carregarPorTipo(params[index]);
  }

  void ordenarEstadoAtual(final String propriedade, final bool ascending) {
    List objetos = tableStateNotifier.value['dataObjects'] ?? [];
    if (objetos == []) return;
    Ordenador ord = Ordenador();
    DecididorOrdenacao d = DecididorOrdenacaoJSON(propriedade, ascending);
    var objetosOrdenados =
        ord.ordenar(objetos, d.precisaTrocarAtualPeloProximo);

    emitirEstadoOrdenado(objetosOrdenados, propriedade, ascending);
  }

  List filtarObjetos() {
    String filtro = tableStateNotifier.value['filterCriteria'];
    List objetos = tableStateNotifier.value['dataObjects'] ?? [];
    if (objetos == []) return [];
    List propriedades = tableStateNotifier.value['propertyNames'];
    Filtrador fil = Filtrador();
    DecididorFiltro d = DecididorFiltroJSON(propriedades);
    List objetosFiltrados = fil.filtrar(objetos, filtro, d.dentroDoFiltro);

    return objetosFiltrados;
  }

  Uri montarUri(ItemType type) {
    return Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/v2/${type.asString}',
        queryParameters: {'size': '$_numberOfItems'});
  }

  Future<List<dynamic>> acessarApi(Uri uri) async {
    var jsonString = await http.read(uri);
    var json = jsonDecode(jsonString);
    json = [...tableStateNotifier.value['dataObjects'], ...json];
    return json;
  }

  void emitirEstadoOrdenado(
      List objetosOrdenados, String propriedade, bool ascending) {
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
      'filterCriteria': ''
    };
  }

  void emitirEstadoPronto(ItemType type, var json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'propertyNames': type.properties,
      'columnNames': type.columns,
      'filterCriteria': ''
    };
  }

  bool temRequisicaoEmCurso() =>
      tableStateNotifier.value['status'] == TableStatus.loading;
  bool mudouTipoDeItemRequisitado(ItemType type) =>
      tableStateNotifier.value['itemType'] != type;

  void carregarPorTipo(ItemType type) async {
    //ignorar solicitação se uma requisição já estiver em curso
    if (temRequisicaoEmCurso()) return;
    if (mudouTipoDeItemRequisitado(type)) {
      emitirEstadoCarregando(type);
    }
    var uri = montarUri(type);
    var json = await acessarApi(uri);
    emitirEstadoPronto(type, json);
  }
}

final dataService = DataService();

class DecididorOrdenacaoJSON extends DecididorOrdenacao {
  final String propriedade;
  final bool crescente;

  DecididorOrdenacaoJSON(this.propriedade, [this.crescente = true]);

  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][propriedade]
              .compareTo(ordemCorreta[1][propriedade]) >
          0;
    } catch (error) {
      return false;
    }
  }
}

class DecididorFiltroJSON extends DecididorFiltro {
  final List propriedades;

  DecididorFiltroJSON(this.propriedades);

  @override
  bool dentroDoFiltro(objeto, filtro) {
    bool achouAoMenosUm = false;
    for (int i = 0; i < propriedades.length; i++) {
      achouAoMenosUm = objeto[propriedades[i]].contains(filtro) ? true : false;
      if (achouAoMenosUm) break;
    }
    return achouAoMenosUm;
  }
}

abstract class DecididorOrdenacao {
  bool precisaTrocarAtualPeloProximo(dynamic atual, dynamic proximo);
}

class Ordenador {
  List ordenar(List objetos, Function callbackDecididor) {
    List objetosOrdenados = List.of(objetos);
    bool trocouAoMenosUm;
    do {
      trocouAoMenosUm = false;
      for (int i = 0; i < objetosOrdenados.length - 1; i++) {
        var atual = objetosOrdenados[i];
        var proximo = objetosOrdenados[i + 1];
        if (callbackDecididor(atual, proximo)) {
          var aux = objetosOrdenados[i];
          objetosOrdenados[i] = objetosOrdenados[i + 1];
          objetosOrdenados[i + 1] = aux;
          trocouAoMenosUm = true;
        }
      }
    } while (trocouAoMenosUm);
    return objetosOrdenados;
  }
}

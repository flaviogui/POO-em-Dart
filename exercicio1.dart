void main() {
  Produto p1 = Produto(preco: 6, descricao: "Cerveja", validade: "25/09/2024");
  Produto p2 = Produto(preco: 10, descricao: "Cachaça", validade: "28/06/2025");
  Produto p3 = Produto(preco: 9, descricao: "Soda", validade: "26/10/2022");

  Item item1 = Item(quantidade: 30, produto: p1);
  Item item2 = Item(quantidade: 5, produto: p2);
  Item item3 = Item(quantidade: 3, produto: p3);

  Venda venda = Venda(data: "13/03/2022", itens: [item1, item2, item3]);
  var total = venda.total2();
  print("Suas compras deram $total reais.");
}

class Produto {
  double preco;
  String descricao;
  String validade;

  Produto(
      {required this.preco, required this.descricao, required this.validade});
}

class Item {
  Produto produto;
  double quantidade;

  Item({required this.quantidade, required this.produto});
  double total1() => this.quantidade * produto.preco;
}

class Venda {
  String data;
  List<Item> itens;
  Venda({required this.data, required this.itens});
  double total2() => itens.fold(0, (sun, e) => sun + e.total1());
}

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
          "DERROTAS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(),
      body: Center(
        child: Column(
          children: [
            Text(
              "Derrota de um valente",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            Text(
              "É outro valente em frente",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            Text(
              "O primeiro é ferido",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            Text(
              "E morre instantaneamente.",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Derrota de um cachaceiro",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            Text(
              "É um grande tropicão",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            Text(
              "Que desapruma o corpo",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            Text(
              "E vai com a cara no chão.",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 18),
            Image.network(
              'https://mercadonegroantiguidades.com.br/wp-content/uploads/2016/05/caneta-pena3.jpg',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // define o item selecionado
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.switch_account_rounded),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_purple500),
            label: 'Estrelar',
          ),
        ],
      ),
    ),
  );
  runApp(app);
}

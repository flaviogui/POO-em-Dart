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
            FadeInImage(
              placeholder: NetworkImage(
                  'https://i.pinimg.com/564x/d6/67/12/d66712decaabceddf507f0f03a98f2a9.jpg'),
              image: NetworkImage(
                  'https://mercadonegroantiguidades.com.br/wp-content/uploads/2016/05/caneta-pena3.jpg'),
              height: 260,
              width: 260,
              fadeInDuration: Duration(milliseconds: 500),
              fadeInCurve: Curves.easeIn,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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

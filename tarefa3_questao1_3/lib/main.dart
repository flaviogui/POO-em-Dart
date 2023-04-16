import 'package:flutter/material.dart';

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: MyAppBar(),
          body: DataBodyWidget(objetos: [
            "La Fin Du Monde - Bock - 65 ibu",
            "Sapporo Premiume - Sour Ale - 54 ibu",
            "Duvel - Pilsner - 82 ibu"
          ]),
          bottomNavigationBar: NewNavBar(
            icone: [
              Icons.coffee_outlined,
              Icons.local_drink_outlined,
              Icons.flag_outlined,
            ],
          ),
        ));
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Dicas"),
      actions: [
        PopupMenuButton<Color>(
            onSelected: (Color color) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<Color>(
                  child: Container(
                    color: Colors.red, // adiciona a cor de fundo
                    child: Text('Vermelho'),
                  ),
                  value: Colors.red,
                ),
                PopupMenuItem<Color>(
                  child: Container(
                    color: Colors.purple,
                    child: Text('Roxo'),
                  ),
                  value: Colors.purple,
                ),
                PopupMenuItem<Color>(
                  child: Container(
                    color: Colors.blue,
                    child: Text('Azul'),
                  ),
                  value: Colors.blue,
                ),
              ];
            }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NewNavBar extends StatelessWidget {
  List<IconData> icone;
  NewNavBar({required this.icone});

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: botaoFoiTocado,
      items: icone
          .map(
            (icone) => BottomNavigationBarItem(
              icon: Icon(icone),
              label: '',
            ),
          )
          .toList(),
    );
  }
}

class DataBodyWidget extends StatelessWidget {
  List<String> objetos;
  DataBodyWidget({this.objetos = const []});

  Expanded processarUmElemento(String obj) {
    return Expanded(
      child: Center(child: Text(obj)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: objetos
            .map((obj) => Expanded(
                  child: Center(child: Text(obj)),
                ))
            .toList());
  }
}

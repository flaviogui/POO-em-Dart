import 'package:flutter/material.dart';

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("ACADEMIA DIGITAL"),
          ),
          body: MyCustomForm(),
        ));
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextField(
            label: 'Primeiro, informe o seu email:',
            hint: 'Exemplo: fulandodarua26@gmail.com',
            icone: Icons.mail),
        SizedBox(
          height: 6,
        ),
        MyTextField(
            label: 'Agora, informe o seu nome:',
            hint: 'Exemplo: Fulano da Silva Saraiva',
            icone: Icons.person),
        MyTextField(
            label: 'Insira o seu número do Whatsapp:',
            hint: 'Exemplo: (83)999000000',
            icone: Icons.phone),
        SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Defina seu estilo de vida: ",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icone;
  const MyTextField(
      {Key? key, required this.label, required this.hint, required this.icone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icone)),
      ),
    );
  }
}

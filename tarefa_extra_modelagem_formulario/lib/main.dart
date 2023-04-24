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
      children: [
        MyTextField(
            label: 'Primeiro, informe o seu email:',
            hint: 'Exemplo: fulandodarua26@gmail.com'),
        SizedBox(
          height: 8,
        ),
        MyTextField(
            label: 'Agora, informe o seu nome:',
            hint: 'Exemplo: Fulano da Silva Saraiva')
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final String hint;
  const MyTextField({Key? key, required this.label, required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}

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

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  String _estiloVida = '';

  void _enviar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processando...'),
      ),
    );
  }

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
        SizedBox(
          height: 6,
        ),
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
            RadioListTile(
              title: Text('Sou uma pessoa sedentária'),
              value: 'Sedentário',
              groupValue: _estiloVida,
              onChanged: (value) {
                setState(() {
                  _estiloVida = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Gosto de fazer atividade física'),
              value: 'Ativo',
              groupValue: _estiloVida,
              onChanged: (value) {
                setState(() {
                  _estiloVida = value.toString();
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _enviar,
          child: Text('ENVIAR'),
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

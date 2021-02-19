import 'package:flutter/material.dart';
import 'listUsers.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
   TextEditingController _controllerName = TextEditingController();
   TextEditingController _controllerEmail= TextEditingController();

   void save() async{
     String nome = _controllerName.text;
     String email = _controllerEmail.text;
     await _salvar(nome, email).then((bool committed) {
     });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text ("Cadastro de usuários"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText:  "Nome completo"
              ),
              controller: _controllerName,
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
            ),

            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText:  "Email"
              ),
              controller: _controllerEmail,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                elevation: 30,
                color: Colors.black,
                child: Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  save();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _salvar(String nome,String email) async {
  List<Users> _valorDigitado = [];

  String valorDigitadoNome = nome;
  String valorDigitadoEmail = email;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("nome", valorDigitadoNome);
  await prefs.setString("email", valorDigitadoEmail);
  _valorDigitado.add(Users(nome, email));


  Users user = Users (valorDigitadoNome,valorDigitadoEmail);
  Map <String, dynamic> map = {
    'name': user.nome,
    'age': user.email
  };
  String rawJson = jsonEncode (map);
  prefs.setString ('data', rawJson);
}

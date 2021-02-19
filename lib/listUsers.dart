import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plug_apps/main.dart';
import 'package:plug_apps/cadastroUsuario.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Users {
  String nome ;
  String email ;

  Users(this.nome, this.email);
}


class listaUsuarios extends StatefulWidget {

  @override
  _listaUsuariosState createState() => _listaUsuariosState();
}

class _listaUsuariosState extends State<listaUsuarios> {
  Users user = Users('teste','teste.com');
   List<Users> _valorDigitado = [];
  getUser()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var c = pref.getString('data');
    var b = pref.getString('data');
    _valorDigitado.insert(0, Users(c,b));
    var a = pref.getString('data');
    print(a);
  }
  @override
  Widget build(BuildContext context) {
  getUser();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text ("Lista de usuários"),
        backgroundColor: Colors.black,
      ),
        body: Column(
          children: <Widget> [
            Expanded(
                child: ListView.builder(
                    itemCount: _valorDigitado.length,
                    itemBuilder:(context, index){
                      final item = _valorDigitado[index];
                      return Dismissible(
                        onDismissed: (direction){
                          print("direcao" + direction.toString());
                        },
                          key: Key(item.nome),
                          child:  ListTile(
                            title: Text(
                              item.nome,
                              style: TextStyle(
                                fontSize: 20,
                                wordSpacing: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(item.email,
                              style: TextStyle(
                                fontSize: 18,
                                wordSpacing: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      );
                    }
                ),
            )
          ],
        ),
    );
  }
}

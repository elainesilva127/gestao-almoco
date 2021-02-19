import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  Future<bool> _salvar(String nome,String email) async {
    String valorDigitadoNome = nome;
    String valorDigitadoEmail = email;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", valorDigitadoNome);
    await prefs.setString("email", valorDigitadoEmail);

    print("operacao(salvar: $valorDigitadoNome && $valorDigitadoEmail");
  }

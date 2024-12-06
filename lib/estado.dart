// ignore_for_file: unnecessary_getters_setters

import 'package:app_filme/autenticacao.dart';
import 'package:flutter/material.dart';

enum Situacao { mostrandoFilmes, mostrandoDetalhes }

class EstadoApp extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoFilmes;
  Situacao get situacao => _situacao;

  late int _idFilme;
  int get idFilme => _idFilme;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? usuario) {
    _usuario = usuario;
  }

  void mostrarFilmes() {
    _situacao = Situacao.mostrandoFilmes;

    notifyListeners();
  }

  void mostrarDetalhes(int idFilme) {
    _situacao = Situacao.mostrandoDetalhes;
    _idFilme = idFilme;

    notifyListeners();
  }

  void onLogin(Usuario usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void onLogout() {
    _usuario = null;

    notifyListeners();
  }
}

late EstadoApp estadoApp;

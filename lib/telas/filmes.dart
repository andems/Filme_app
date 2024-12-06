import 'dart:convert';

import 'package:app_filme/autenticacao.dart';
import 'package:app_filme/componentes/cardFilme.dart';
import 'package:app_filme/estado.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:toast/toast.dart";

class Filmes extends StatefulWidget {
  const Filmes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilmesState();
  }
}

const int tamanhoPagina = 6;

class _FilmesState extends State<Filmes> {
  late dynamic _telaEstatico;
  List<dynamic> _filmes = [];

  int _proximaPagina = 1;
  bool _carregando = true;

  late TextEditingController _controladorFiltragem;
  String _filtro = "";

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _controladorFiltragem = TextEditingController();
    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    final String conteudoJson =
        await rootBundle.loadString("lib/recursos/jsons/feed.json");
    _telaEstatico = await json.decode(conteudoJson);

    _carregarFilmes();
  }

  void _carregarFilmes() {
    setState(() {
      _carregando = true;
    });

    var maisFilmes = [];
    if (_filtro.isNotEmpty) {
      _telaEstatico["filmes"].where((item) {
        String nome = item["filme"]["name"];

        return nome.toLowerCase().contains(_filtro.toLowerCase());
      }).forEach((item) {
        maisFilmes.add(item);
      });
    } else {
      maisFilmes = _filmes;

      final totalFilmesParaCarregar = _proximaPagina * tamanhoPagina;
      if (_telaEstatico["filmes"].length >= totalFilmesParaCarregar) {
        maisFilmes =
            _telaEstatico["filmes"].sublist(0, totalFilmesParaCarregar);
      }
    }

    setState(() {
      _filmes = maisFilmes;
      _proximaPagina++;

      _carregando = false;
    });
  }

  Future<void> _atualizarFilmes() async {
    _filmes = [];
    _proximaPagina = 1;

    _carregarFilmes();
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 60, right: 20),
                    child: TextField(
                      controller: _controladorFiltragem,
                      onSubmitted: (descricao) {
                        _filtro = descricao;

                        _atualizarFilmes();
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
                    ))),
            usuarioLogado
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        estadoApp.onLogout();
                      });

                      Toast.show("Você não está mais conectado",
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                    },
                    icon: const Icon(Icons.logout))
                : IconButton(
                    onPressed: () {
                      Usuario usuario =
                          Usuario("Anderson", "mendesandersonms@gmail.com");

                      setState(() {
                        estadoApp.onLogin(usuario);
                      });

                      Toast.show("Você foi conectado com sucesso",
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                    },
                    icon: const Icon(Icons.login))
          ],
        ),
        body: FlatList(
            data: _filmes,
            numColumns: 2,
            loading: _carregando,
            onRefresh: () {
              _filtro = "";
              _controladorFiltragem.clear();

              return _atualizarFilmes();
            },
            onEndReached: () => _carregarFilmes(),
            buildItem: (item, int indice) {
              return SizedBox(height: 580, child: CardFilme(filme: item));
            }));
  }
}
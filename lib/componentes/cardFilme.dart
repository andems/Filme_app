
import 'package:app_filme/estado.dart';
import 'package:flutter/material.dart';

class CardFilme extends StatelessWidget {
  final dynamic filme;

  const CardFilme({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {

    String filmeId = filme["_id"].toString();

    String imagePath =
        "lib/recursos/imagens/filme$filmeId.jpg";

    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(filme["_id"]);
      },
      child: Card(
        child: Column(children: [
          Image.asset(imagePath),
          Row(children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(imagePath)),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(filme["company"]["name"],
                    style: const TextStyle(fontSize: 15))),
          ]),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(filme["filme"]["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
              child: Text(filme["filme"]["description"])),
          const Spacer(),
          Row(children: [
            Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Text("R\$ ${filme['filme']['price'].toString()}")),
            Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 5),
                child: Row(children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 18),
                  Text(filme["likes"].toString())
                ])),
          ])
        ]),
      ),
    );
  }
}
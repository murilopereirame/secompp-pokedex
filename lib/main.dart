import 'package:flutter/material.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/components/pokemon_card.dart';
import 'package:pokedex_secompp/utils.dart';

void main() {
  runApp(const Pokedex());
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: const MaterialColor(900, {
            50: Color.fromRGBO(112, 145, 154, .1),
            100: Color.fromRGBO(112, 145, 154, .2),
            200: Color.fromRGBO(112, 145, 154, .3),
            300: Color.fromRGBO(112, 145, 154, .4),
            400: Color.fromRGBO(112, 145, 154, .5),
            500: Color.fromRGBO(112, 145, 154, .6),
            600: Color.fromRGBO(112, 145, 154, .7),
            700: Color.fromRGBO(112, 145, 154, .8),
            800: Color.fromRGBO(112, 145, 154, .9),
            900: Color.fromRGBO(112, 145, 154, 1),
          }),
          backgroundColor: const Color(0xFFFFFFFF),
          primaryColor: const Color(0xFF000000),
          highlightColor: const Color(0xFFFFFFFF)),
      home: const PokemonList(title: 'Flutter Demo Home Page'),
    );
  }
}

class PokemonList extends StatefulWidget {
  const PokemonList({super.key, required this.title});

  final String title;

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PokemonCard(
                pokemon: Pokemon(4, "Charmander", [pokemonTypes["fire"]!],
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png"))
          ],
        ),
      ),
    );
  }
}

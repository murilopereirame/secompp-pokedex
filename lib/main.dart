import 'package:flutter/material.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/components/pokemon_card.dart';
import 'package:pokedex_secompp/network.dart';
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
  ScrollController? _scrollController;
  final List<Pokemon> _pokeList = [];
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {     
    _scrollController = ScrollController(initialScrollOffset: 5.0)
    ..addListener(_scrollListener);    

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void loadPokemons() async {
    setState(() {
      _isLoading = true;
    });

    if(_isLoading) {
      List<Pokemon> tempPkn = await Network.getPokemonList(_page);
      setState(() {
        _pokeList.addAll(tempPkn);
        _page++;
        _isLoading = false;
      });      
    }
  }

  _scrollListener() {
    if(_scrollController == null) {
      return;
    }
      

    if (_scrollController != null && _scrollController!.offset >= 
    _scrollController!.position.maxScrollExtent && 
    !_scrollController!.position.outOfRange) {
     loadPokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: GridView.count(
          crossAxisCount: 2,
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          physics: const AlwaysScrollableScrollPhysics(),
          children: _pokeList.map((e) => PokemonCard(pokemon: e)).toList()
        ),
      )
    );
  }
}

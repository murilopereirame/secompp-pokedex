import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/components/pokemon_card.dart';
import 'package:pokedex_secompp/network.dart';
import 'package:pokedex_secompp/screens/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  ScrollController? _scrollController;  
  final List<Pokemon> _pokeList = [];
  int _page = 0;

  bool _onlyFavorites = false;
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

  _loadPokemons() async {
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

  _loadFavoritesPokemons() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];

    if(_isLoading) {
      List<Pokemon> tempPkn = await Network.getFavoritePokemonList(favorites, _page);
      setState(() {
        _pokeList.addAll(tempPkn);
        _page++;
        _isLoading = false;
      });      
    }
  }

  _handleOnlyFavorites() {
    if(_onlyFavorites) {
      setState(() {
        _pokeList.clear();
        _page = 0;
        _onlyFavorites = false;
        _loadPokemons();        
      });
    } else {
      setState(() {
        _pokeList.clear();
        _page = 0;
        _onlyFavorites = true;
        _loadFavoritesPokemons();
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
      if(_onlyFavorites) {
        _loadFavoritesPokemons();
      }
      else {
      _loadPokemons();
      }
    }
  }

  _handlePokemonTap(Pokemon pokemon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PokemonDetailsScreen(
          pokemon: pokemon
        )
      )
    );
  }

  int _calculateGridItems() {    
    double width = MediaQuery.of(context).size.width;

    if(width > 1280) {
      return 7;
    }
    if(width > 1144) {
      return 6;
    }
    else if(width > 920) {
      return 5;
    } 
    else if(width > 715) {
      return 4;
    } else if(width > 550) {
      return 3;
    }

    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _handleOnlyFavorites,        
        backgroundColor: Colors.red,
        child: Icon(_onlyFavorites ? Icons.favorite : Icons.favorite_border),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0, left: 7.5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pokedex',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Theme.of(context).colorScheme.secondary
                          ),
                        ),
                      ]
                    )
                  ),
                  Expanded(                  
                    child: Stack(            
                      fit: StackFit.passthrough,
                      children: [              
                        Positioned(                    
                          right: 0,
                          bottom: 0,
                          child: Image.asset(
                            "images/pokeball.png",
                            scale: .75,
                          )
                        )
                      ]
                    )
                  )
                ]
              )
            )
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 7.5, right: 7.5),
              child: GridView.count(
                crossAxisCount: _calculateGridItems(),
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                mainAxisSpacing: 7.5,
                crossAxisSpacing: 7.5,
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: _pokeList.map(
                  (e) => PokemonCard(
                    pokemon: e, 
                    onTap: () => _handlePokemonTap(e)
                  )
                ).toList()
              ),
            )
          )
        ]
      )
    );
  }
}

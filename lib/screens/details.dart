import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/components/stats_info.dart';
import 'package:pokedex_secompp/utils.dart';
import 'package:pokedex_secompp/components/basic_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailsScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> with TickerProviderStateMixin{
  late ScrollController _scrollController;

  bool _isLoading = true;
  bool _isFavorite = false;
  bool _transparentAppbar = true;

  @override
  void initState() {    
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if(!mounted) return;
      
      if(_scrollController.offset < 450 && !_scrollController.position.outOfRange){                
        setState(() => _transparentAppbar = true);
      }
      if(_scrollController.offset >= 450 && !_scrollController.position.outOfRange){
        setState(()  => _transparentAppbar = false);
      }
    });

    _checkFavorite();
  }

  _checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? favorites = prefs.getStringList('favorites');

    if(favorites != null && favorites.contains(widget.pokemon.pokedexId.toString())) {
      setState(() {
        _isFavorite = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  _handleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? favorites = prefs.getStringList('favorites');

    if(_isFavorite) {
      favorites?.remove(widget.pokemon.pokedexId.toString());
      setState(() {
        _isFavorite = false;
      });
    } else {
      favorites?.add(widget.pokemon.pokedexId.toString());
      setState(() {
        _isFavorite = true;
      });
    }

    prefs.setStringList("favorites", favorites ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _transparentAppbar ? 
          Colors.transparent : 
          widget.pokemon.types.first.colors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${capitalizeWords(widget.pokemon.name, "-", replace: " ")} #${widget.pokemon.pokedexId}",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 28
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _handleFavorite,
            child: SizedBox(
              width: 56,  
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_outline, 
                color: _isFavorite ? Colors.red : Colors.white,
                size: 24,
              )
            )
          )
        ],        
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : 
      SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: 500,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  decoration: BoxDecoration(
                    color: widget.pokemon.types.first.colors.primary,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -35,
                        left: 0,
                        child: Image.asset("images/pokeball_2.png", scale: .75),                    
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 5),
                        child: Image
                          .network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${widget.pokemon.pokedexId}.png",
                          loadingBuilder:
                            (context, child, loadingProgress) => 
                              loadingProgress == null ? 
                                child : 
                                CircularProgressIndicator(
                                  color: widget.pokemon.types.first.colors.accent
                                )
                          ),
                      )
                    ]
                  )
                ),
              ]
            ),            
            BaiscInfoWidget(pokemon: widget.pokemon),
            StatsInfoWidget(pokemon: widget.pokemon)
          ],
        ),
      )      
    );
  }
}
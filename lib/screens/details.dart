import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailsScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${toBeginningOfSentenceCase(widget.pokemon.name)} #${widget.pokemon.pokedexId}",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 28
          ),
        ),
        actions: const [
          SizedBox(
            width: 56,  
            child: Icon(
              Icons.favorite_outline, 
              size: 24,
            )
          )
        ],        
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
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
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400
              ),
              child: DefaultTabController(
                length: 2, 
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.transparent,
                      labelColor: Theme.of(context).primaryColor,
                      labelPadding: const EdgeInsets.only(top: 15, bottom: 15),
                      labelStyle: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      unselectedLabelColor: const Color(0xFFBDB8B8),
                      tabs: const [
                        Text('About'),
                        Text('Stats')
                      ]
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          Icon(Icons.abc),
                          Icon(Icons.abc_outlined)
                        ]
                      )
                    ),
                  ]
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
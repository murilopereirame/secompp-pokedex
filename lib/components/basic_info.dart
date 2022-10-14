import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/evolution.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/components/evolution.dart';
import 'package:pokedex_secompp/components/pokemon_info.dart';

class BaiscInfoWidget extends StatefulWidget {
  final Pokemon pokemon;
  const BaiscInfoWidget({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<BaiscInfoWidget> createState() => _BaiscInfoWidgetState();
}

class _BaiscInfoWidgetState extends State<BaiscInfoWidget> {
  final List<Widget> _evolutions = [];
  bool _isLoading = true;

  @override
  void initState() {  
    super.initState();

    setState(() {
      _evolutions.add(EvolutionCard(evolution: widget.pokemon.evolutionChain));
      _evolutions.addAll(
        navigateThroughEntries(
          widget.pokemon.evolutionChain.pokemonName, 
          widget.pokemon.evolutionChain.evolvesTo
        )
      );

      _isLoading = false;
    });
  }

  List<Widget> navigateThroughEntries(String from, List<Evolution> evolutionTree) {
    List<Widget> temp = [];
    for(Evolution evo in evolutionTree) {
      temp.add(EvolutionCard(evolution: evo, evolvesFrom: from));
      temp.addAll(navigateThroughEntries(evo.pokemonName, evo.evolvesTo));
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Basic Info",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            )
          ),
          PokemonInfo(infoLabel: "Generation:", infoValue: widget.pokemon.generation),
          PokemonInfo(infoLabel: "Height:", infoValue: "${widget.pokemon.height}m"),
          PokemonInfo(infoLabel: "Height:", infoValue: "${widget.pokemon.weight}Kg"),
          PokemonInfo(infoLabel: "Abilities:", infoValue: widget.pokemon.abilities.join(", ")),
          const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider()
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Family",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            )
          ),
          !_isLoading ? 
            GridView.count(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                childAspectRatio: 21/9,
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10, 
                padding: EdgeInsets.zero,
                children: _evolutions,
              ) : const Center(child: CircularProgressIndicator()
            ),
          const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider()
          ),
        ],
      )
    );
  }
}
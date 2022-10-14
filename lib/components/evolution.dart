import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/evolution.dart';

class EvolutionCard extends StatelessWidget {
  final Evolution evolution;
  final String? evolvesFrom;
  const EvolutionCard({Key? key, required this.evolution, this.evolvesFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  evolvesFrom != null ? "From $evolvesFrom" : "Base",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evolution.pokemonId}.png", 
                  width: 96, 
                  height: 96,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(evolution.pokemonName, 
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              )
                            )
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(evolution.trigger.join(", "), 
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.montserrat()
                            )
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(evolution.triggerTarget.join(", "), 
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.montserrat(
                                fontSize: 12
                              )
                            )
                          )
                        ]
                      )
                    ],
                  )
                )
              )
            ],
          )
        ],
      )
    );
  }
}
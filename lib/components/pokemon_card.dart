import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/classes/type.dart';
import 'package:pokedex_secompp/components/type_card.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final Function()? onTap;
  const PokemonCard({Key? key, required this.pokemon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: pokemon.types.first.colors.primary,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${pokemon.pokedexId}",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Theme.of(context).highlightColor
                    ),
                  ),
                  Text(
                    pokemon.name,
                    style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Theme.of(context).highlightColor)
                  )
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,              
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for(PokemonType type in pokemon.types)
                        TypeCard(type: type),
                    ],
                  ),
                  Image.network(pokemon.image, width: 94, height: 94,)
                ],
              )
            ],
          )
        )
      )
    );
  }
}

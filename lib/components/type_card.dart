import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/type.dart';

class TypeCard extends StatelessWidget {
  final PokemonType type;
  const TypeCard({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(      
      width: 65,
      height: 24,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: type.colors.accent,
        borderRadius: BorderRadius.circular(4.25)
      ),
      child: Text(
          type.name,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).highlightColor,
            fontSize: 16,
          ),        
      ),
    );
  }
}
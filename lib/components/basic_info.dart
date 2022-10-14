import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';

class BaiscInfo extends StatelessWidget {
  final Pokemon pokemon;
  const BaiscInfo({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Basic Info",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
        ),
        Row(
          children: [
            Text(
              'Generation',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).disabledColor
              ),
            ),
          ],
        )
      ],
    );
  }
}
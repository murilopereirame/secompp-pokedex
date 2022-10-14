import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonStatWidget extends StatelessWidget {
  final String infoLabel;
  final String infoValue;
  final double statPercent;
  final Color progressColor;
  
  const PokemonStatWidget({
    Key? key, 
    required this.infoLabel, 
    required this.infoValue, 
    required this.statPercent,
    required this.progressColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 150
          ),
          child: Text(
            infoLabel,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).disabledColor
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 40
          ),
            child: Text(
            infoValue,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).primaryColor
            ),
          ),
        ),
        Flexible(
          child: LinearProgressIndicator(
            value: statPercent / 100.0,
            backgroundColor: Theme.of(context).cardColor,
            color: progressColor,
            minHeight: 10,
          )
        )
      ],
    );
  }
}
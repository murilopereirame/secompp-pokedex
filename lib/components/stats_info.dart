import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_secompp/classes/multiplier.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:pokedex_secompp/classes/stat.dart';
import 'package:pokedex_secompp/components/pokemon_info.dart';
import 'package:pokedex_secompp/components/pokemon_stat.dart';
import 'package:pokedex_secompp/utils.dart';

class StatsInfoWidget extends StatefulWidget {
  final Pokemon pokemon;
  const StatsInfoWidget({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<StatsInfoWidget> createState() => _StatsInfoWidgetState();
}

class _StatsInfoWidgetState extends State<StatsInfoWidget> {
  MultiplierType _selectedMultiplier = MultiplierType.attack;

  _changeMultiplier() {
    setState(
      () => _selectedMultiplier = 
        _selectedMultiplier == MultiplierType.attack ? 
        MultiplierType.defense : MultiplierType.attack
    );
  }

  Color _getColor(String stat) {
    switch(stat) {
      case "hp":
        return const Color(0xFFE70C0C);
      case "attack":
        return const Color(0xFFFEA800);
      case "defense":
        return const Color(0xFF0C64E7);
      case "special-attack":
        return const Color(0xFFFFDF34);
      case "special-defense":
        return const Color(0xFF9AE8E3);
      case "speed":
        return const Color(0xFF0CE798);
      case "overall":
        return const Color(0xFFA10CE7);
      default:
        return const Color(0xFFA10CE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Base Stats",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            )
          ),
          for(PokemonStat stat in widget.pokemon.stats)
            PokemonStatWidget(
              infoLabel: capitalizeWords(stat.name, "-", replace: " "), 
              infoValue: stat.base.toString(), 
              statPercent: (stat.base * 100.0) / 255.0, 
              progressColor: _getColor(stat.name)
            ),
          PokemonStatWidget(
            infoLabel: "Overall", 
            infoValue: widget
              .pokemon
              .stats
              .reduce(
                (value, element) => PokemonStat(
                  "Overal", 
                  value.base + element.base
                )
              ).base.toString(), 
            statPercent: widget
              .pokemon
              .stats
              .reduce(
                (value, element) => PokemonStat(
                  "Overal", 
                  value.base + element.base
                )
              ).base * 100.0 / 1530.0, 
            progressColor: _getColor("Overall")
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider()
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Multipliers",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                GestureDetector(
                  onTap: _changeMultiplier,
                  child: Row(
                    children: [
                      Text(
                        'Attack',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: _selectedMultiplier == MultiplierType.attack ? 
                          Theme.of(context).hintColor : 
                          Theme.of(context).disabledColor
                        ),
                      ),                    
                      Text(
                        '/',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor
                        ),
                      ),
                      Text(
                        'Defense',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: _selectedMultiplier == MultiplierType.defense ? 
                          Theme.of(context).hintColor : 
                          Theme.of(context).disabledColor
                        ),
                      ), 
                    ],
                  )
                )
              ]
            )
          ),
          for(
            MapEntry<double, List<String>> multiplier in 
            widget.pokemon.multipliers[_selectedMultiplier]!.multipliers.entries
          )
            PokemonInfo(infoLabel: "${multiplier.key}x", infoValue: multiplier.value.join(", ")),
        ],
      ),
    );
  }
}
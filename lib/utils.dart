import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokedex_secompp/classes/multiplier.dart';
import 'package:pokedex_secompp/classes/pokemon_type_color.dart';
import 'package:pokedex_secompp/classes/type.dart';
import 'package:pokedex_secompp/network.dart';

Map<String, PokemonType> pokemonTypes = {
  'normal': PokemonType("Normal",
      PokemonTypeColor(const Color(0xFFA8A77A), const Color(0xFF616040))),
  'fire': PokemonType("Fire",
      PokemonTypeColor(const Color(0xBFFA973B), const Color(0xFFFA8700))),
  'water': PokemonType("Water",
      PokemonTypeColor(const Color(0xBF3B9EFA), const Color(0xFF0055FA))),
  'grass': PokemonType("Grass",
      PokemonTypeColor(const Color(0xAF7CB153), const Color(0xFF77CB80))),
  'electric': PokemonType("Electric",
      PokemonTypeColor(const Color(0xCFEDD261), const Color(0xFFF7D02C))),
  'ice': PokemonType("Ice",
      PokemonTypeColor(const Color(0xFF96D9D6), const Color(0xFF37807C))),
  'fighting': PokemonType("Fighting",
      PokemonTypeColor(const Color(0xFFF56862), const Color(0xFFC22E28))),
  'poison': PokemonType("Poison",
      PokemonTypeColor(const Color(0xFFF283F0), const Color(0xFFA33EA1))),
  'ground': PokemonType("Ground",
      PokemonTypeColor(const Color(0xFFD9BF7E), const Color(0xFFE2BF65))),
  'flying': PokemonType("Flying",
      PokemonTypeColor(const Color(0xFFA98FF3), const Color(0xFF5C42A8))),
  'psychic': PokemonType("Psychic",
      PokemonTypeColor(const Color(0xFFF781A5), const Color(0xFFF95587))),
  'bug': PokemonType("Bug",
      PokemonTypeColor(const Color(0xFFACB85A), const Color(0xFFA6B91A))),
  'rock': PokemonType("Rock",
      PokemonTypeColor(const Color(0xFFBDAf6C), const Color(0xFFB6A136))),
  'ghost': PokemonType("Ghost",
      PokemonTypeColor(const Color(0xFF807391), const Color(0xFF735797))),
  'dark': PokemonType("Dark",
      PokemonTypeColor(const Color(0xFFAB9485), const Color(0xFF705746))),
  'dragon': PokemonType("Dragon",
      PokemonTypeColor(const Color(0xFFBCA4F5), const Color(0xFF6F35FC))),
  'steel': PokemonType("Steel",
      PokemonTypeColor(const Color(0xFFB7B7CE), const Color(0xFF434369))),
  'fairy': PokemonType("Fairy",
      PokemonTypeColor(const Color(0xFFD685AD), const Color(0xFFDE2f85))),
};


String? extractIdFromURL(String url) {
  RegExp regex = RegExp(r'/([^/]*)/$');
  return regex.allMatches(url).first.group(0)?.replaceAll("/", "");
}

String capitalizeWords(String phrase, String regex, {String? replace}) {
  return phrase.splitMapJoin(
    RegExp(regex), 
    onMatch: (p0) => replace ?? p0.group(0) ?? "",
    onNonMatch: (p1) => toBeginningOfSentenceCase(p1) ?? ""
  );
}

Future<Map<MultiplierType, PokemonMultiplier>> calculateMultipliers(List<dynamic> types) async {
  Map<String, double> attack = {};
  Map<String, double> defense = {};

  for(dynamic item in types) {
    Map<String, dynamic> typeData = await Network
      .getTypeDetails(item["type"]["url"].toString());
    
    for(dynamic relation in typeData["damage_relations"].entries) {
      String key = relation.key;
      for(dynamic multiplier in relation.value) {
        String typeName = multiplier["name"];

        if(key == "double_damage_from") {
          if(defense.containsKey(typeName)) {
            defense[typeName] = defense[typeName]! * 2;
          } else {
            defense[typeName] = 2;
          }          
        } else if(key == "double_damage_to") {
          if(attack.containsKey(typeName)) {
            attack[typeName] = attack[typeName]! * 2;
          } else {
            attack[typeName] = 2;
          }
        } else if(key == "half_damage_from") {
          if(defense.containsKey(typeName)) {
            defense[typeName] = defense[typeName]! * 0.5;
          } else {
            defense[typeName] = 0.5;
          }
        } else if(key == "half_damage_to") {
          if(attack.containsKey(typeName)) {
            attack[typeName] = attack[typeName]! * 0.5;
          } else {
            attack[typeName] = 0.5;
          }
        } else if(key == "no_damage_from") {
          if(defense.containsKey(typeName)) {
            defense[typeName] = defense[typeName]! * 0;
          } else {
            defense[typeName] = 0;
          }
        } else if(key == "half_damage_to") {
          if(defense.containsKey(typeName)) {
            defense[typeName] = defense[typeName]! * 0;
          } else {
            defense[typeName] = 0;
          }
        }
      }
    }
  }

  SplayTreeMap<double, List<String>> attackMultipliers = SplayTreeMap();
  SplayTreeMap<double, List<String>> defenseMultipliers = SplayTreeMap();

  attack.forEach((key, value) {
    String capital = capitalizeWords(key, "-", replace: " ");

    if(attackMultipliers.containsKey(value)) {
      attackMultipliers[value]!.add(capital);
    } else {
      attackMultipliers[value] = [capital];
    }
  });

  defense.forEach((key, value) {
    String capital = capitalizeWords(key, "-", replace: " ");

    if(defenseMultipliers.containsKey(value)) {
      defenseMultipliers[value]!.add(capital);
    } else {
      defenseMultipliers[value] = [capital];
    }
  });
  
  attackMultipliers = SplayTreeMap.from(attackMultipliers, (a, b) => a.compareTo(b));
  defenseMultipliers = SplayTreeMap.from(defenseMultipliers, (a, b) => a.compareTo(b));

  return {
    MultiplierType.attack : PokemonMultiplier(MultiplierType.attack, Map.from(attackMultipliers)),
    MultiplierType.defense : PokemonMultiplier(MultiplierType.defense, Map.from(defenseMultipliers))
  };
}
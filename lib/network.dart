import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pokedex_secompp/classes/evolution.dart';
import 'package:pokedex_secompp/classes/multiplier.dart';
import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_secompp/classes/stat.dart';
import 'package:pokedex_secompp/classes/type.dart';
import 'package:pokedex_secompp/utils.dart';

class Network {
  static Future<List<Pokemon>> getPokemonList(int page) async {
    int offset = page*15;

    http.Response result = await http.get(    
      Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=15&offset=$offset"));

    Map<String, dynamic> pokemonsResume = jsonDecode(result.body);

    var pokemonsList = pokemonsResume["results"].map((e) {
        return getPokemon(e["url"]);
      }
    );
    
    return await Future.wait(Iterable.castFrom(pokemonsList.toList()));
  }

  static Future<List<Pokemon>> getFavoritePokemonList(List<String> favorites, int page) async {
    int count = page * 15;

    if(favorites.length < count) {
      return [];
    }
    
    var pokemonsList = favorites.skip(count).map((e) {
        return getPokemon("https://pokeapi.co/api/v2/pokemon/$e");
      }
    );
    
    return await Future.wait(Iterable.castFrom(pokemonsList.toList()));
  }

  static Future<Pokemon> getPokemon(String pokemonUrl) async {
    http.Response result = await http.get(
      Uri.parse(pokemonUrl));

    Map<String, dynamic> pokemonInfo = jsonDecode(result.body);  

    List<PokemonType> types = List<PokemonType>.from(pokemonInfo["types"].map(
      (e) => pokemonTypes[e["type"]["name"]]).toList());

    Map<MultiplierType, PokemonMultiplier> pokemonMultipliers = 
      await calculateMultipliers(pokemonInfo["types"]);

    int pokemonId = pokemonInfo["id"];
    String pokemonImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png";

    List<String> pokemonAbilities = 
      pokemonInfo["abilities"].map<String>(
        (e) => capitalizeWords(e['ability']['name'].toString(), "-", replace: " ")
      ).toList();

    List<PokemonStat> pokemonStats = pokemonInfo["stats"]
      .map<PokemonStat>(
        (e) => PokemonStat(e['stat']['name'], e['base_stat'])
      ).toList();

    Evolution pokemonEvoChain = await getEvolutionChain(pokemonId);
 
    String pokemonGeneration = await getGeneration(pokemonId);

    return Pokemon(
      pokemonId, 
      pokemonInfo["name"], 
      types, 
      pokemonImage, 
      pokemonAbilities,
      pokemonInfo["height"] / 10.0,
      pokemonInfo["weight"] / 10.0,
      pokemonStats,
      pokemonMultipliers,
      pokemonGeneration,
      pokemonEvoChain
    );
  }

  static Future<Map<String, dynamic>> getTypeDetails(String url) async {
    http.Response result = await http.get(Uri.parse(url));

    return jsonDecode(result.body);
  }

  static Future<String> getGeneration(int pokemonId) async {
    http.Response result = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon-species/$pokemonId"));

    Map<String, dynamic> specieInfo = jsonDecode(result.body);

    String genName = specieInfo["generation"]["name"]
      .toString()
      .splitMapJoin(
        RegExp(r"generation-"), 
        onMatch: (p0) => capitalizeWords(p0.group(0) ?? "", "-", replace: " "),
        onNonMatch: (p1) => p1.toUpperCase()
      );
    int genIndex = int.parse(extractIdFromURL(specieInfo["generation"]["url"]) ?? "0");

    return "$genIndex - $genName";
  }

  static Future<Evolution> getEvolutionChain(int pokemonId) async {
    http.Response result = await http.get(
      Uri.parse("https://pokeapi.co/api/v2/pokemon-species/$pokemonId"));

    Map<String, dynamic> pokemonInfo = jsonDecode(result.body);

    http.Response resultChain = await http.get(
      Uri.parse(pokemonInfo["evolution_chain"]["url"])
    );

    Map<String, dynamic> evoChain = jsonDecode(resultChain.body);    
    String basePokemonId = extractIdFromURL(evoChain["chain"]["species"]["url"]) ?? "0";
    
    Evolution baseEvo = Evolution(
      int.parse(basePokemonId), 
      ["Base"], 
      capitalizeWords(
        evoChain["chain"]["species"]["name"].toString(), 
        "-", 
        replace: " "
      )
    );
    baseEvo.pokemonName = capitalizeWords(
      evoChain["chain"]["species"]["name"].toString(),
      "-",
      replace: " "
    );
    baseEvo.buildTriggerTarget(evoChain["chain"]["evolution_details"]);
    baseEvo.evolvesTo.addAll(getNextEvolution(evoChain["chain"]["evolves_to"]));
    
    return baseEvo;
  }

  static List<Evolution> getNextEvolution(List<dynamic> evoList) {
    List<Evolution> evos = [];
    for(LinkedHashMap<String, dynamic> evolution in evoList) {
      String basePokemonId = extractIdFromURL(evolution["species"]["url"]) ?? "0";
      List<String> trigger = evolution["evolution_details"]
        .map<String>(
          (e) => 
            capitalizeWords(
              e["trigger"]["name"].toString(), 
              "-", 
              replace: " "
            )
        ).toList();
      trigger = Set<String>.from(trigger).toList();
      
      Evolution tempEvo = Evolution(
        int.parse(basePokemonId), 
        trigger, 
        capitalizeWords(evolution["species"]["name"], "-", replace: " ")
      );
      tempEvo.pokemonName = capitalizeWords(
        evolution["species"]["name"].toString(), 
        "-", 
        replace: " "
      );
      tempEvo.evolvesTo.addAll(getNextEvolution(evolution["evolves_to"]));
      tempEvo.buildTriggerTarget(evolution["evolution_details"]);
      evos.add(tempEvo);
    }

    return evos;
  }
}
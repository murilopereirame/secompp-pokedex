import 'dart:convert';

import 'package:pokedex_secompp/classes/pokemon.dart';
import 'package:http/http.dart' as http;
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

  static Future<Pokemon> getPokemon(String pokemonUrl) async {
    http.Response result = await http.get(
      Uri.parse(pokemonUrl));

    Map<String, dynamic> pokemonInfo = jsonDecode(result.body);  

    List<PokemonType> types = List<PokemonType>.from(pokemonInfo["types"].map(
      (e) => pokemonTypes[e["type"]["name"]]).toList());

    int pokemonId = pokemonInfo["id"];
    String pokemonImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png";

    return Pokemon(pokemonId, pokemonInfo["name"], types, pokemonImage);
  }
}
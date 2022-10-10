import 'package:pokedex_secompp/classes/type.dart';

class Pokemon {
  List<PokemonType> types;
  int pokedexId;
  String name;
  String image;

  Pokemon(this.pokedexId, this.name, this.types, this.image);
}

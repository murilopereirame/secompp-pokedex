class Evolution {
  int pokemonId;
  List<String> trigger;
  List<Evolution> evolvesTo = [];
  String? pokemonName;
  int? level;
  String? condition;
  String? item;

  Evolution(this.pokemonId, this.trigger);
}
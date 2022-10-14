enum MultiplierType {
  attack,
  defense
}
class PokemonMultiplier {
  MultiplierType type;
  Map<double, List<String>> multipliers;

  PokemonMultiplier(this.type, this.multipliers);
}
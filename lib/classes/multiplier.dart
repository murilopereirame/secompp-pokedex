enum MultiplierType {
  attack,
  defense
}
class Multiplier {
  MultiplierType type;
  Map<double, List<String>> multipliers;

  Multiplier(this.type, this.multipliers);
}
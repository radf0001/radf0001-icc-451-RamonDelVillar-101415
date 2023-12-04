
class PokemonMoreInfoData {
  // more info tab
  int? height;
  int? weight;
  List<String>? types;
  List<String>? moves;
  List<String>? abilities;
  String? speciesUrl;

  // more info tab
  PokemonMoreInfoData({
    this.height,
    this.speciesUrl,
    this.weight,
    this.types,
    this.moves,
    this.abilities,
  });
}
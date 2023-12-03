
class PokemonAboutData {
  // about tab
  int? baseHappiness;
  int? captureRate;
  String? flavorText;
  String? habitat;
  String? growthRate;
  List<String>? eggGroups;
  String? evolutionsUrl;



  // Base stats tab

  PokemonAboutData({
    // about tab
    required this.baseHappiness,
    required this.captureRate,
    required this.eggGroups,
    required this.flavorText,
    required this.habitat,
    required this.growthRate,
    required this.evolutionsUrl
    // Base Stats tab
  });
}
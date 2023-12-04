import 'dart:ui';

import 'package:personalizado/models/pokemon_about_data.dart';
import 'package:personalizado/models/pokemon_evolutions_data.dart';
import 'package:personalizado/models/pokemon_more_info_data.dart';
import 'package:personalizado/models/pokemon_stats.dart';

class PokemonBasicData {
  final String name;
  String id;
  String imageUrl;
  PokemonAboutData? pokemonAboutData;
  PokemonMoreInfoData? pokemonMoreInfoData;
  PokemonStatsData? pokemonStatsData;
  List<PokemonEvolutionData>? pokemonEvolutionData;

  PokemonBasicData({
    required this.name,
    required this.id,
    this.pokemonAboutData,
    required this.imageUrl,
    this.pokemonMoreInfoData,
    this.pokemonStatsData,
    this.pokemonEvolutionData,
  });
}
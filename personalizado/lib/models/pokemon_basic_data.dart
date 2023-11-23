import 'dart:ui';

import 'package:personalizado/models/pokemon_about_data.dart';
import 'package:personalizado/models/pokemon_more_info_data.dart';
import 'package:personalizado/models/pokemon_stats.dart';

class PokemonBasicData {
  final String name;
  String id;
  Color? cardColor;
  PokemonAboutData? pokemonAboutData;
  PokemonMoreInfoData? pokemonMoreInfoData;
  PokemonStatsData? pokemonStatsData;

  PokemonBasicData({
    required this.name,
    required this.id,
    this.pokemonAboutData,
    this.cardColor,
    this.pokemonMoreInfoData,
    this.pokemonStatsData,
  });
}
import 'package:flutter/material.dart';
import '../../models/pokemon_basic_data.dart';
import '../../models/pokemon_more_info_data.dart';
import 'pokemon_info_list_widget.dart';
import 'title_and_subtitle_widget.dart';

class MoreInfoWidget extends StatelessWidget {
  final PokemonBasicData pokemon;

  const MoreInfoWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    int height = 0;
    int weight = 0;
    List<String> types = [];
    // List<String> moves = [];
    List<String> abilities = [];
    if (pokemon.pokemonMoreInfoData != null) {
      final PokemonMoreInfoData pokemonMoreInfoData = pokemon.pokemonMoreInfoData!;
      height = pokemonMoreInfoData.height!;
      weight = pokemonMoreInfoData.weight!;
      types = pokemonMoreInfoData.types!;
      // moves = pokemonMoreInfoData.moves!;
      abilities = pokemonMoreInfoData.abilities!;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubtitleWidget(title: 'Height', subtitle: height.toString(), titleColor: Colors.white),
            TitleAndSubtitleWidget(title: 'Weight', subtitle: weight.toString(), titleColor: Colors.white),
            // types names list
            PokemonInfoListWidget(listTitle: 'Types', pokemonData: types, listTitleColor: Colors.white, types: true),
            // moves names list
            // PokemonInfoListWidget(listTitle: 'Moves', pokemonData: moves),
            // abilities names list
            // const SizedBox(height: 16),
            const Divider(height: 5),
            const SizedBox(height: 8),
            PokemonInfoListWidget(listTitle: 'Abilities', pokemonData: abilities, listTitleColor: Colors.white, types: false,),
          ],
        ),
      ),
    );
  }
}
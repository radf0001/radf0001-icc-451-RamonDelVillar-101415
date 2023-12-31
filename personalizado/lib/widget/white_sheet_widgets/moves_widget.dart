import 'package:flutter/material.dart';
import '../../models/pokemon_basic_data.dart';
import '../../models/pokemon_more_info_data.dart';
import 'pokemon_info_list_widget.dart';

class MovesWidget extends StatelessWidget {
  final PokemonBasicData pokemon;

  const MovesWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {

    List<String> moves = [];
    if (pokemon.pokemonMoreInfoData != null) {
      final PokemonMoreInfoData pokemonMoreInfoData = pokemon.pokemonMoreInfoData!;
      moves = pokemonMoreInfoData.moves!;
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

            // moves names list
            PokemonInfoListWidget(listTitle: 'Moves', pokemonData: moves, listTitleColor: Colors.white, types: false,),
          ],
        ),
      ),
    );
  }
}
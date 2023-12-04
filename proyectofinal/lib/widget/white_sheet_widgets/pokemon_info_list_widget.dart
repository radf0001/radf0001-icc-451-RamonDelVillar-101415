import 'package:flutter/material.dart';

class PokemonInfoListWidget extends StatelessWidget {
  final List<String> pokemonData;
  final String listTitle;
  final Color listTitleColor;

  const PokemonInfoListWidget({Key? key, required this.pokemonData, required this.listTitle, required this.listTitleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$listTitle:',
            style: TextStyle(fontWeight: FontWeight.bold, color: listTitleColor, fontFamily: 'PokemonSolid')),
        ...pokemonData.map((groupName) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Text(groupName, style: const TextStyle(color: Colors.white, fontFamily: 'PokemonHollow', fontSize: 12)),
            ],
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
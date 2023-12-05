import 'package:flutter/material.dart';

class PokemonInfoListWidget extends StatelessWidget {
  final List<String> pokemonData;
  final String listTitle;
  final Color listTitleColor;
  final bool types;

  const PokemonInfoListWidget(
      {super.key,
      required this.pokemonData,
      required this.listTitle,
      required this.listTitleColor,
      required this.types});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$listTitle:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        ...pokemonData.asMap().entries.map((entry) {
          int index = entry.key;
          String groupName = entry.value;
          return Column(
            children: [
              const SizedBox(height: 8),
              types
                  ? Row(
                children: [
                  Text(
                    "${index+1}. $groupName ",
                    style: const TextStyle(
                      fontSize: 16,
                        color: Colors.white
                    ),
                  ),
                  Image.asset(
                    'lib/images/types/$groupName.png',
                    width: 30,
                  ),
                ],
              )
                  : Text(
                "${index+1}. $groupName",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

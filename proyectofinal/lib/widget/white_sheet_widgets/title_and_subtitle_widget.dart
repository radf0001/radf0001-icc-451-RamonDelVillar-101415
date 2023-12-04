import 'package:flutter/material.dart';

class TitleAndSubtitleWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color titleColor;
  const TitleAndSubtitleWidget({Key? key, required this.title, required this.subtitle, required this.titleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title:',
            style: TextStyle(fontWeight: FontWeight.bold, color: titleColor, fontFamily: 'PokemonSolid')),
        const SizedBox(height: 8),
        Text(subtitle.toString(), style: const TextStyle(color: Colors.white, fontFamily: 'PokemonHollow', fontSize: 12)),
        const SizedBox(height: 16),
        const Divider(height: 5),
        const SizedBox(height: 8),
      ],
    );
  }
}
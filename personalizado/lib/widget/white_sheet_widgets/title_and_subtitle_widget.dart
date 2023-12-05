import 'package:flutter/material.dart';

class TitleAndSubtitleWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color titleColor;
  const TitleAndSubtitleWidget({super.key, required this.title, required this.subtitle, required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle.toString(), style: const TextStyle(
            fontSize: 16,
            color: Colors.white
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 5),
        const SizedBox(height: 8),
      ],
    );
  }
}
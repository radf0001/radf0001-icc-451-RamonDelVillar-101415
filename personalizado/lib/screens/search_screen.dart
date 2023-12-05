import 'package:flutter/material.dart';

import '../widget/search_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search Pokemons By: ', style: TextStyle(color: Colors.yellowAccent, fontFamily: "PokemonHollow"),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}

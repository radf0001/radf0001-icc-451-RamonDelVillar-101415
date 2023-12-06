import 'package:flutter/material.dart';
import 'package:personalizado/models/pokemon_basic_data.dart';
import '../services/pokemon_favorite.dart';
import '../widget/white_sheet_widgets/white_sheet_widget.dart';
import 'package:flutter_share/flutter_share.dart';


class PokemonDetailScreen extends StatefulWidget {
  final PokemonBasicData pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final pokemonFavoriteService = PokemonFavoritesController();

  Future<void> share() async {
    await FlutterShare.share(
        title: '${widget.pokemon.id} ${widget.pokemon.name}',
        text: '${widget.pokemon.id} ${widget.pokemon.name}',
        linkUrl: 'https://pokeapi.co/api/v2/pokemon/${widget.pokemon.id}/',
        chooserTitle: '${widget.pokemon.id} ${widget.pokemon.name}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;

    Future<void> checkFavorite(String idAndName) async {
      isFavorite = await pokemonFavoriteService.isPokemonFavorite(idAndName);
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              share();
            },
            icon: const Icon(Icons.share),
            color: Colors.white,
          ),
          FutureBuilder(
              future: checkFavorite("${widget.pokemon.id} ${widget.pokemon.name}"),
              builder: (context, dataSnapShot) {
                return IconButton(
                    onPressed: () async {
                      await pokemonFavoriteService
                          .toggleFavoritePokemon("${widget.pokemon.id} ${widget.pokemon.name}");
                      setState(() {

                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: isFavorite
                          ? Colors.pinkAccent
                          : Colors.white,
                    ));
              }),
        ],
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Builder(
          builder: (context) {
            return WhiteSheetWidget(pokemon: widget.pokemon);
          }
      ),
      backgroundColor: Colors.white,
    );
  }
}

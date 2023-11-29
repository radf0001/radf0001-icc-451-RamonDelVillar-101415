import 'package:flutter/material.dart';
import 'package:personalizado/models/pokemon_basic_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/pokemon_favorite.dart';
import '../widget/white_sheet_widgets/white_sheet_widget.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokemonBasicData pokemon;

  const PokemonDetailScreen({Key? key, required this.pokemon})
      : super(key: key);

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final pokemonFavoriteService = PokemonFavoritesController();

  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;

    Future<void> checkFavorite(String idAndName) async {
      isFavorite = await pokemonFavoriteService.isPokemonFavorite(idAndName);
    }

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            // padding: EdgeInsets.only(top: constants.mediumPadding, right: constants.mediumPadding),
            color: widget.pokemon.cardColor,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                // get status bar height and top screen padding
                SizedBox(height: MediaQuery.of(context).viewPadding.top-10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 40)),
                        const Text("")
                      ],
                    ),
                    Column(
                      children: [
                        Text("${widget.pokemon.id} ",
                            style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'PokemonHollow', fontSize: 15)),
                        Text("${widget.pokemon.name} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'PokemonHollow', fontSize: 15)),
                      ],
                    ),
                    Column(
                      children: [
                        Hero(
                          tag: "${widget.pokemon.id} ${widget.pokemon.name}",
                          child: FutureBuilder(
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
                                          ? widget.pokemon.cardColor ==
                                          Colors.redAccent
                                          ? Colors.blueAccent
                                          : Colors.redAccent
                                          : Colors.white,
                                      size: 40,
                                    ));
                              }),
                        ),
                        const Text(""),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: WhiteSheetWidget(pokemon: widget.pokemon),
                      ),
                      SizedBox(
                          height: screenHeight * 0.32,
                          width: screenWidth,
                          child: Hero(
                            tag: widget.pokemon.id,
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl:
                                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemon.id}.png",
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          widget.pokemon.cardColor ==
                                                  Colors.redAccent
                                              ? Colors.blueAccent
                                              : Colors.redAccent)),
                              errorWidget: (context, url, error) =>
                                  CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl:
                                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${widget.pokemon.id}.png",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    widget.pokemon.cardColor ==
                                                            Colors.redAccent
                                                        ? Colors.blueAccent
                                                        : Colors.redAccent)),
                                errorWidget: (context, url, error) =>
                                    CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png",
                                  progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  widget.pokemon.cardColor ==
                                                          Colors.redAccent
                                                      ? Colors.blueAccent
                                                      : Colors.redAccent)),
                                  errorWidget: (context, url, error) =>
                                      const Text(""),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}

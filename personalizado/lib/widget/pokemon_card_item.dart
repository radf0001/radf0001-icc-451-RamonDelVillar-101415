import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

import '../models/pokemon_basic_data.dart';
import '../screens/pokemon_detail_screen.dart';
import '../services/pokemon_favorite.dart';

class PokemonCardItem extends StatefulWidget {
  final dynamic pokemonResult;
  final int index;

  const PokemonCardItem(
      {Key? key,
        required this.pokemonResult,
        required this.index})
      : super(key: key);

  @override
  State<PokemonCardItem> createState() => _PokemonCardItemState();
}

class _PokemonCardItemState extends State<PokemonCardItem> {
  final pokemonFavoriteService = PokemonFavoritesController();
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
    final dynamic id = widget.pokemonResult['url'].split('/')[6];
    Color cardColor = widget.index.isEven ? Colors.redAccent : Colors.blueAccent;
    List<Color> gradient = [
      cardColor,
      cardColor,
      Colors.white,
      Colors.white,
    ];

    // update ids and imageUrls
    return InkWell(
      key: Key(id),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(pokemon: PokemonBasicData(id: id, name: widget.pokemonResult['name'], cardColor: cardColor)),
            ));
        setState(() {

        });
      },
      child: Padding(
        key: Key(id),
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: gradient,
              stops: const [0.0, 0.5, 0.5, 1.0],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 3,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white),
              ),
              widget.index.isEven ? SvgPicture.asset("lib/images/redPokeBall.svg") : SvgPicture.asset("lib/images/bluePokeball.svg"),
              SizedBox(
                width: 150,
                height: 150,
                child: Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png",
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress, valueColor: AlwaysStoppedAnimation<Color>(widget.index.isEven ?Colors.blueAccent : Colors.redAccent)),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png",
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress, valueColor: AlwaysStoppedAnimation<Color>(widget.index.isEven ?Colors.blueAccent : Colors.redAccent)),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png",
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress, valueColor: AlwaysStoppedAnimation<Color>(widget.index.isEven ?Colors.blueAccent : Colors.redAccent)),
                        errorWidget: (context, url, error) => const Text(""),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -5,
                left: -5,
                child: Hero(
                  tag: "$id ${widget.pokemonResult['name']}",
                  child: FutureBuilder(
                      future: checkFavorite("$id ${widget.pokemonResult['name']}"),
                      builder: (context, dataSnapShot) {
                        return IconButton(
                            onPressed: () async {
                              await pokemonFavoriteService
                                  .toggleFavoritePokemon("$id ${widget.pokemonResult['name']}");
                              setState(() {

                              });
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite
                                  ? cardColor ==
                                  Colors.redAccent
                                  ? Colors.blueAccent
                                  : Colors.redAccent
                                  : Colors.white,
                              size: 30,
                            ));
                      }),
                ),
              ),
              Positioned(
                top: 0,
                right: 8,
                child: Text(id.toString().padLeft(5, '0'),
                  style: const TextStyle(color: Colors.white, fontFamily: 'PokemonSolid'),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 8,
                  child: SizedBox(
                    width: 185,
                    child: Text(widget.pokemonResult['name'],
                      style: const TextStyle(color: Colors.black, fontFamily: 'PokemonSolid'),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

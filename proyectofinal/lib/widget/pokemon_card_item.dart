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
      {super.key, required this.pokemonResult, required this.index});

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
    final dynamic id = widget.pokemonResult['url'].split('/')[6];
    String imageUrl =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png";

    // update ids and imageUrls
    return InkWell(
      key: Key(id),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(
                  pokemon: PokemonBasicData(
                id: id,
                name: widget.pokemonResult['name'],
                imageUrl: imageUrl,
              )),
            ));
      },
      child: Column(
        key: Key(id),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity:
                      0.8, // Ajusta este valor a la opacidad que deseas, por ejemplo 0.5 para el 50%
                  child: SvgPicture.asset(
                    "lib/images/img_group_95.svg",
                    width: MediaQuery.of(context).size.width / 3.5,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Hero(
                    tag: id,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.index.isEven
                                          ? Colors.blueAccent
                                          : Colors.redAccent)),
                      errorWidget: (context, url, error) {
                        imageUrl =
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png";
                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          widget.index.isEven
                                              ? Colors.blueAccent
                                              : Colors.redAccent)),
                          errorWidget: (context, url, error) {
                            imageUrl =
                                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          widget.index.isEven
                                              ? Colors.blueAccent
                                              : Colors.redAccent)),
                              errorWidget: (context, url, error) {
                                imageUrl = "";
                                return const Text("");
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.pokemonResult['name'],
            style: Theme.of(context).textTheme.titleMedium!.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
          ),
          Text(
            "#${id.toString().padLeft(5, '0')}",
            style: Theme.of(context).textTheme.titleSmall!.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

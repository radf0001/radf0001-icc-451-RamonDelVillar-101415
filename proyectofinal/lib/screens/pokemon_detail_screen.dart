import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:personalizado/models/pokemon_basic_data.dart';
import 'package:personalizado/screens/search_screen.dart';
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
  Color? cardColor = Colors.transparent;

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
        leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 40)
        ),
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
          IconButton(
            onPressed: () async{
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SearchScreen(),
                  ));
              setState(() {

              });
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Builder(
          builder: (context) {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: cardColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(' ${widget.pokemon.id}',
                            style: const TextStyle(color: Colors.white, fontFamily: 'PokemonSolid', fontSize: 20),
                          ),
                          const Spacer(),
                          Text('${widget.pokemon.name} ',
                            style: const TextStyle(color: Colors.white, fontFamily: 'PokemonSolid', fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Hero(
                          tag: widget.pokemon.id,
                          child: widget.pokemon.imageUrl.isNotEmpty ? CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: widget.pokemon.imageUrl,
                            progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                            errorWidget: (context, url, error) {
                              return const Text("ERROR IMAGE");
                            },
                          ) : const Text("NO IMAGE"),
                        ),
                      ),
                    ],
                  ),
                ),
                WhiteSheetWidget(pokemon: widget.pokemon),
              ],
            );
          }
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}

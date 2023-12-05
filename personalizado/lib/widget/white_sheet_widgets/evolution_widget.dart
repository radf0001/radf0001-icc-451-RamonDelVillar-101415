import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:personalizado/models/pokemon_basic_data.dart';
import 'package:personalizado/models/pokemon_evolutions_data.dart';

import '../../screens/pokemon_detail_screen.dart';
import '../../utils/bottom_to_top.dart';

class EvolutionWidget extends StatelessWidget {
  final PokemonBasicData pokemon;

  const EvolutionWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    late List<PokemonEvolutionData> evolutions = [];
    if (pokemon.pokemonEvolutionData != null) {
      evolutions = pokemon.pokemonEvolutionData?? [];
      evolutions.removeWhere((objeto) => objeto.id == pokemon.id);
    }

    if(evolutions.isEmpty){
      return const Center(child: Text("NO EVOLUTIONS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)));
    }
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: evolutions.length,
        itemBuilder: (context, index) {
          String imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evolutions[index].id!}.png";
          return InkWell(
            key: Key(evolutions[index].id!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(" ${evolutions[index].id} ${evolutions[index].name}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                  const Spacer(),
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evolutions[index].id!}.png",
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                      errorWidget: (context, url, error) {
                        imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${evolutions[index].id!}.png";
                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${evolutions[index].id!}.png",
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                          errorWidget: (context, url, error) {
                            imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolutions[index].id!}.png";
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolutions[index].id!}.png",
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                              errorWidget: (context, url, error) {
                                return const Text("");
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 10),
              ],
            ),
            onTap: () {
              if(MediaQuery.of(context).viewInsets.bottom > 0) {
                FocusManager.instance.primaryFocus?.unfocus();
              }else{
                Navigator.of(context).push(AnimatedRoute(PokemonDetailScreen(pokemon: PokemonBasicData(id: evolutions[index].id!, name: evolutions[index].name!, imageUrl: imageUrl))));
              }
            },
          );
        }
    );
  }
}
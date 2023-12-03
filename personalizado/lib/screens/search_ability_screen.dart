import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:personalizado/screens/pokemon_detail_screen.dart';

import '../models/pokemon_basic_data.dart';

class SearchedAbilityScreen extends StatefulWidget {
  final String abilityName;
  const SearchedAbilityScreen({Key? key, required this.abilityName}) : super(key: key);

  @override
  State<SearchedAbilityScreen> createState() => _SearchedAbilityScreenState();
}

class _SearchedAbilityScreenState extends State<SearchedAbilityScreen> {
  @override
  Widget build(BuildContext context) {
    String flavorText = '';
    List<String> pokemons = [];

    Future<void> getAbilityData() async {
      Map<String, dynamic> abilityData = {};
      final List<String> pokemonsNames = [];
      try {
        final String abilityLowerCase = widget.abilityName.toLowerCase();
        final url = Uri.parse('https://pokeapi.co/api/v2/ability/$abilityLowerCase');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final fetchedData = json.decode(response.body);
          // get only the first flavor text
          // final String flavorText = fetchedData['flavor_text_entries'][0]['flavor_text'];
          final String flavorText = fetchedData['flavor_text_entries']
              .where((entry) => entry['language']['name'] == 'en')
              .map((entry) => entry['flavor_text'])
              .first;
          // get the pokemons who have the ability
          final fetchedPokemons = fetchedData['pokemon'];
          for (var pokemon in fetchedPokemons) {
            // convert the pokemon name first letter to upper case and add it to the list of pokemons
            pokemonsNames.add(pokemon['pokemon']['url'].split('/')[6] + " " + pokemon['pokemon']['name'].substring(0, 1).toUpperCase() +
                pokemon['pokemon']['name'].substring(1));
          }

          abilityData = {
            'flavorText': flavorText,
            'pokemonsNames': pokemonsNames,
          };
        }
      } catch (error) {
        rethrow;
      }
      flavorText = abilityData['flavorText'];
      pokemons = abilityData['pokemonsNames'];
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
        backgroundColor: Colors.black,
        title: Text(widget.abilityName, style: const TextStyle(fontFamily: "PokemonHollow", color: Colors.yellowAccent),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: getAbilityData(),
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(93, 95, 122, 1),));
          } else{
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ability Description:', style: TextStyle(color: Colors.grey, fontFamily: "PokemonSolid", fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(flavorText, style: const TextStyle(color: Colors.white, fontFamily: "PokemonSolid", fontSize: 15)),
                  const SizedBox(height: 32),
                  Text('Pokemons with this ability: ${pokemons.length}', style: const TextStyle(color: Colors.grey, fontFamily: "PokemonSolid", fontSize: 20)),
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: pokemons.length,
                        itemBuilder: (context, index) {
                          final String pokemonName = pokemons[index];
                          return InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(children: [
                                  Text(pokemonName, style: const TextStyle(color: Colors.white, fontFamily: "PokemonSolid", fontSize: 15)),
                                  const Spacer(),
                                  SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: Hero(
                                      tag: pokemonName.split(' ')[0],
                                      child: CachedNetworkImage(
                                        fit: BoxFit.contain,
                                        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemonName.split(' ')[0]}.png",
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                                        errorWidget: (context, url, error) => CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemonName.split(' ')[0]}.png",
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              CircularProgressIndicator(value: downloadProgress.progress, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                                          errorWidget: (context, url, error) => CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemonName.split(' ')[0]}.png",
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(value: downloadProgress.progress, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                                            errorWidget: (context, url, error) => const Text(""),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],),
                                const SizedBox(height: 16),
                                const Divider(height: 5),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetailScreen(pokemon: PokemonBasicData(id: pokemonName.split(' ')[0], name: pokemonName.split(' ')[1], cardColor: index.isEven ?Colors.blueAccent : Colors.redAccent)),
                                  ));
                            },
                          );
                        }),
                  ),
                ],
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}

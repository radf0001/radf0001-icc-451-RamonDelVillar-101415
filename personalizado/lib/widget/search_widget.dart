import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import '../models/pokemon_basic_data.dart';
import '../screens/pokemon_detail_screen.dart';
import '../screens/search_ability_screen.dart';
import '../utils/bottom_to_top.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool isNameFilterSelected = false;
  bool isAbilityFilterSelected = false;
  List<String> namesAndIdList = [];
  List<String> abilitiesList = [];
  List<String> searchList = [];
  List<String> resultList = [];
  final textEditController = TextEditingController();
  String subText = '';

  @override
  void initState() {
    isNameFilterSelected = true;
    fetchAllPokemonsIdAndNames();
    fetchAllAbilities();
    searchList = namesAndIdList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void updateResultList(String text) {
      setState(() {
        subText = text;
        resultList = searchList
            .where((item) => item.toLowerCase().contains(text))
            .toList();
      });
    }

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              ChoiceChip(
                  backgroundColor: Colors.black,
                  label: const Text('Id or Name',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  selectedColor: Colors.redAccent,
                  selected: isNameFilterSelected,
                  onSelected: (selectValue) {
                    setState(() {
                      isNameFilterSelected = true;
                      isAbilityFilterSelected = false;
                      // when filter changes clear the result list
                      resultList = [];
                    });
                    // when filter changes clear the textField
                    textEditController.clear();
                    searchList = namesAndIdList;
                  }),
              const SizedBox(width: 16),
              ChoiceChip(
                  backgroundColor: Colors.black,
                  label: const Text('Ability',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  selectedColor: Colors.redAccent,
                  selected: isAbilityFilterSelected,
                  onSelected: (selectValue) {
                    setState(() {
                      isAbilityFilterSelected = true;
                      isNameFilterSelected = false;
                      // when filter changes clear the result list
                      resultList = [];
                    });
                    // when filter changes clear the textField
                    textEditController.clear();
                    searchList = abilitiesList;
                  }),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 64,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(235, 243, 245, 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: TextField(
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        controller: textEditController,
                        cursorColor: const Color.fromRGBO(90, 94, 121, 1),
                        decoration: InputDecoration(
                            hintText: isNameFilterSelected
                                ? 'Type the name of the Pokemon'
                                : 'Type the name of the ability',
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(149, 151, 174, 1)),
                            border: InputBorder.none,
                            // disable the underline in the TextField
                            icon: const Icon(
                              Icons.search,
                              color: Color.fromRGBO(90, 94, 121, 1),
                            )),
                        onChanged: (value) {
                          updateResultList(value.toLowerCase());
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: resultList.length,
                        itemBuilder: (context, index) {
                          final resultText = " ${resultList[index]}";
                          String imageUrl =
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${resultList[index].split(' ')[0]}.png";
                          return InkWell(
                            key: Key(resultList[index].split(' ')[0]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(resultText,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18)),
                                    const Spacer(),
                                    isNameFilterSelected
                                        ? SizedBox(
                                            width: 75,
                                            height: 75,
                                            child: Hero(
                                              tag: resultList[index]
                                                  .split(' ')[0],
                                              child: CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                imageUrl:
                                                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${resultList[index].split(' ')[0]}.png",
                                                progressIndicatorBuilder: (context,
                                                        url,
                                                        downloadProgress) =>
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.black)),
                                                errorWidget:
                                                    (context, url, error) {
                                                  imageUrl =
                                                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${resultList[index].split(' ')[0]}.png";
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${resultList[index].split(' ')[0]}.png",
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                            valueColor:
                                                                const AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .black)),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      imageUrl =
                                                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${resultList[index].split(' ')[0]}.png";
                                                      return CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${resultList[index].split(' ')[0]}.png",
                                                        progressIndicatorBuilder: (context,
                                                                url,
                                                                downloadProgress) =>
                                                            CircularProgressIndicator(
                                                                value:
                                                                    downloadProgress
                                                                        .progress,
                                                                valueColor:
                                                                    const AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .black)),
                                                        errorWidget: (context,
                                                            url, error) {
                                                          imageUrl = "";
                                                          return const Text("");
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : const Text(""),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(height: 10),
                              ],
                            ),
                            onTap: () {
                              if (MediaQuery.of(context).viewInsets.bottom >
                                  0) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              } else {
                                if (isNameFilterSelected) {
                                  Navigator.of(context).push(AnimatedRoute(
                                      PokemonDetailScreen(
                                          pokemon: PokemonBasicData(
                                              id: resultList[index]
                                                  .split(' ')[0],
                                              name: resultList[index]
                                                  .split(' ')[1],
                                              imageUrl: imageUrl))));
                                } else {
                                  Navigator.of(context).push(AnimatedRoute(
                                      SearchedAbilityScreen(
                                          abilityName: resultList[index])));
                                }
                              }
                            },
                          );
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchAllPokemonsIdAndNames() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1292');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final fetchedPokemons = json.decode(response.body)['results'];
        for (var pokemonData in fetchedPokemons) {
          // convert first letter to uppercase
          final String pokemonName = pokemonData['url'].split('/')[6] +
              " " +
              pokemonData['name'].substring(0, 1).toUpperCase() +
              pokemonData['name'].substring(1);
          namesAndIdList.add(pokemonName);
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllAbilities() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/ability?limit=363');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final fetchedAbilities = json.decode(response.body)['results'];
        for (var pokemonData in fetchedAbilities) {
          // convert first letter to uppercase
          final String ability =
              pokemonData['name'].substring(0, 1).toUpperCase() +
                  pokemonData['name'].substring(1);
          abilitiesList.add(ability);
        }
      }
    } catch (error) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_about_data.dart';
import '../models/pokemon_basic_data.dart';
import '../models/pokemon_evolutions_data.dart';
import '../models/pokemon_more_info_data.dart';
import '../models/pokemon_stats.dart';
import "dart:math";

class HttpCalls{
  Future<void> getPokemonAboutData(PokemonBasicData pokemon) async {
    PokemonAboutData pokemonAboutData;
    // convert the pokemon name to lower case so we can use it in the url
    Uri url = Uri.parse(pokemon.pokemonMoreInfoData!.speciesUrl!);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var pokemonInfo = json.decode(response.body);
        var baseHappiness = pokemonInfo['base_happiness'];
        int captureRate = pokemonInfo['capture_rate'];
        var habitatData = pokemonInfo['habitat'];
        String habitat = 'Unknown'; // not every pokemon has this data
        if (habitatData != null) {
          habitat = habitatData['name'];
        }
        String evolutionChain = pokemonInfo['evolution_chain']['url'];
        String growthRate = pokemonInfo['growth_rate']['name'];
        // get only the first text
        List<String> myList =[];
        String flavorTextEdited = 'Unknown';
        try{
          for(dynamic temp in pokemonInfo['flavor_text_entries']){
            if(temp["language"]["name"] == "en"){
              String flavorText = "${temp['flavor_text'].toLowerCase().replaceAll(RegExp('\n'), ' ').replaceAll(RegExp('’'), "'").replaceAll(RegExp("\f"), ' ')}";
              if(!myList.contains(flavorText)){
                myList.add(flavorText);
              }
            }
          }
          if(myList.isNotEmpty){
            // generates a new Random object
            final random = Random();
            flavorTextEdited = myList[random.nextInt(myList.length)];
          }
        }catch(e){
          flavorTextEdited = 'Unknown';
        }

        // extract egg groups names from the map
        List<String> eggGroupNames = [];
        List eggGroups = pokemonInfo['egg_groups'];
        for (var eggGroup in eggGroups) {
          eggGroupNames.add(eggGroup['name']);
        }
        pokemonAboutData = PokemonAboutData(
          baseHappiness: baseHappiness,
          captureRate: captureRate,
          habitat: habitat,
          growthRate: growthRate,
          flavorText: flavorTextEdited,
          eggGroups: eggGroupNames,
          evolutionsUrl: evolutionChain
        );
        pokemon.pokemonAboutData = pokemonAboutData;
      }
    } catch (error) {
      rethrow;
    }
  }


  Future<void> getPokemonEvolutionData(PokemonBasicData pokemon) async {
    var url = Uri.parse(pokemon.pokemonAboutData!.evolutionsUrl!);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var pokemonInfo = json.decode(response.body);
        List<PokemonEvolutionData> evolutions = [];
        _parseEvolutionChain(pokemonInfo['chain'], evolutions);

        pokemon.pokemonEvolutionData = evolutions;
      }
    } catch (error) {
      rethrow;
    }
  }

  void _parseEvolutionChain(Map<String, dynamic> chain, List<PokemonEvolutionData> evolutions) {
    if (chain['species'] != null) {
      var speciesUrl = chain['species']['url'];

      evolutions.add(PokemonEvolutionData(
        name: chain['species']['name'],
        url: speciesUrl,
        id: speciesUrl.split('/')[6],
      ));
    }

    if (chain['evolves_to'] != null && chain['evolves_to'].isNotEmpty) {
      for (var nextChain in chain['evolves_to']) {
        _parseEvolutionChain(nextChain, evolutions);
      }
    }
  }

  Future<void> fetchPokemonMoreIndoData(PokemonBasicData pokemon) async {
    PokemonMoreInfoData moreInfo;

    // convert the pokemon name to lower case so we can use it in the url
    String pokemonNameLowerCase = pokemon.name.toLowerCase();

    try {
      final Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonNameLowerCase');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var pokemonData = json.decode(response.body);
        int height = pokemonData['height'];
        int weight = pokemonData['weight'];

        // extract types names
        List<String> typesNames = [];
        List types = pokemonData['types'];
        for (var typeName in types) {
          typesNames.add(typeName['type']['name']);
        }

        // extract moves names
        List<String> movesNames = [];
        List moves = pokemonData['moves'];
        for (var moveName in moves) {
          movesNames.add(moveName['move']['name']);
        }

        // extract abilities names
        List<String> abilitiesNames = [];
        List abilities = pokemonData['abilities'];
        for (var abilityName in abilities) {
          abilitiesNames.add(abilityName['ability']['name']);
        }

        moreInfo = PokemonMoreInfoData(
          height: height,
          weight: weight,
          types: typesNames,
          moves: movesNames,
          abilities: abilitiesNames,
          speciesUrl: pokemonData['species']['url']
        );
        pokemon.pokemonMoreInfoData = moreInfo;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchPokemonStats(PokemonBasicData pokemon) async {
    PokemonStatsData pokemonStats;
    // convert the pokemon name to lower case so we can use it in the url
    String pokemonNameLowerCase = pokemon.name.toLowerCase();

    try {
      final Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonNameLowerCase');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var pokemonData = json.decode(response.body);
        List statsData = pokemonData['stats'];
        int hp = 0;
        int attack = 0;
        int defence = 0;
        int specialAttack = 0;
        int specialDefence = 0;
        int speed = 0;

        hp = statsData[0]['base_stat'];
        attack = statsData[1]['base_stat'];
        defence = statsData[2]['base_stat'];
        specialAttack = statsData[3]['base_stat'];
        specialDefence = statsData[4]['base_stat'];
        speed = statsData[5]['base_stat'];


        pokemonStats = PokemonStatsData(
          hp: hp,
          attack: attack,
          defense: defence,
          specialAttack: specialAttack,
          specialDefence: specialDefence,
          speed: speed
        );
        pokemon.pokemonStatsData = pokemonStats;
      }
    } catch (error) {
      rethrow;
    }
  }

  // get pokemon data by name
  Future<Map<String, dynamic>> getPokemonByName(String name) async {
    Map<String, dynamic> pokemon = {};
    final nameLowerCase = name.toLowerCase();
    try {
      final Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$nameLowerCase');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final pokemonData = json.decode(response.body);
        // convert id to 3 digits such as: 001, 002, 003, etc
        int id = pokemonData['id'];
        pokemon = {
          'name': name,
          'id': id.toString(),
        };
      }
      return pokemon;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPokemonByNameWithUrl(String name) async {
    Map<String, dynamic> pokemon = {};
    final nameLowerCase = name.toLowerCase();
    try {
      final Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$nameLowerCase');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final pokemonData = json.decode(response.body);
        int id = pokemonData['id'];
        pokemon = {
          'name': name,
          'url': 'https://pokeapi.co/api/v2/pokemon/$id',
        };
      }
      return pokemon;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPokemonById(String id) async {
    Map<String, dynamic> pokemon = {};
    try {
      final Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final pokemonData = json.decode(response.body);
        // convert id to 3 digits such as: 001, 002, 003, etc
        String name = pokemonData['name'];
        pokemon = {
          'name': name,
          'id': id.toString(),
        };
      }
      return pokemon;
    } catch (error) {
      rethrow;
    }
  }
}
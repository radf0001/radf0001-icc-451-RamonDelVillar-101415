import 'package:shared_preferences/shared_preferences.dart';

class PokemonFavoritesController {

  // handle favorite pokemons
  late SharedPreferences prefs;

  List<String> favoritePokemonsIdsAndsNames = [];

  List<String> get favoritePokemonsIdsAndNames {
    return [...favoritePokemonsIdsAndsNames];
  }

  // toggle pokemons from sharedPreferences
  Future<void> toggleFavoritePokemon(String pokemonIdAndName) async {
    pokemonIdAndName = pokemonIdAndName.toLowerCase();
    prefs = await SharedPreferences.getInstance();
    // first get the favorite list from sharedPrefs
    List<String>? savedPokemons = [];
    savedPokemons = prefs.getStringList('favoritePokemons');

    // if the there in no saved pokemons the list is null so make it equal empty
    savedPokemons ??= [];

    if (savedPokemons.contains(pokemonIdAndName)) {
      // if the list contain the pokemon delete it
      savedPokemons.removeWhere((idAndName) => pokemonIdAndName == idAndName);
    } else {
      // if the list doesn't have the pokemon add it
      savedPokemons.add(pokemonIdAndName);
    }
    prefs.setStringList('favoritePokemons', savedPokemons);
    favoritePokemonsIdsAndsNames = savedPokemons;
  }

  // load favorite pokemons names from sharedPreferences
  Future<void> loadFavoritePokemonsNamesFromSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? savedPokemons = [];
    savedPokemons = prefs.getStringList('favoritePokemons');
    // if the there in no saved pokemons the list is null so make it equal empty
    savedPokemons ??= [];
    // sort the list alphabetically descending
    favoritePokemonsIdsAndsNames = savedPokemons;
  }

  // Check if pokemon is favorite in sharedPreferences
  Future<bool> isPokemonFavorite(String pokemonIdAndName) async {
    pokemonIdAndName = pokemonIdAndName.toLowerCase();
    prefs = await SharedPreferences.getInstance();
    // check if the pokemon name is in the saved list
    List<String>? savedPokemons = [];
    savedPokemons = prefs.getStringList('favoritePokemons');

    // if the there in no saved pokemons the list is null so make it equal empty
    savedPokemons ??= [];
    if (savedPokemons.contains(pokemonIdAndName)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> jsonGetFavoritePokemonsData() async {
    List<Map<String, dynamic>> favPokemons = [];
    // load favorite pokemons data from shared pref
    await loadFavoritePokemonsNamesFromSharedPref();
    for (String idAndName in favoritePokemonsIdsAndsNames) {
      favPokemons.add({
        'name': idAndName.split(' ')[1],
        'url': "https://pokeapi.co/api/v2/pokemon/${idAndName.split(' ')[0]}/",
      });
    }
    return favPokemons;
  }
}
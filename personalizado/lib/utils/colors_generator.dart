import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../models/pokemon_basic_data.dart';
import 'package:http/http.dart' as http;

class ColorsGenerator {
  // generate a color for the card dynamically based on the Pokemon color
  Future<Color> generateCardColor(PokemonBasicData pokemon) async {
    // set default color if the palette can't generate color if the image didn't load successfully.
    PaletteGenerator paletteGenerator;
    Uri url = Uri.parse("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png");
    try{
      final response = await http.get(url);
      if (response.statusCode == 200) {
        paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png"));
        return paletteGenerator.dominantColor!.color.withAlpha(500);
        // return paletteGenerator.dominantColor!.color.withOpacity(0.25);
      }else{
        url=Uri.parse("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemon.id}.png");
        final response = await http.get(url);
        if (response.statusCode == 200) {
          paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemon.id}.png"));
          return paletteGenerator.dominantColor!.color.withAlpha(500);
          // return paletteGenerator.dominantColor!.color.withOpacity(0.25);
        }else {
          url=Uri.parse("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png");
          final response = await http.get(url);
          if (response.statusCode == 200) {
            paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png"));
            return paletteGenerator.dominantColor!.color.withAlpha(500);
            // return paletteGenerator.dominantColor!.color.withOpacity(0.25);
          }else {
            return pokemon.cardColor!;
          }
        }
      }
    }catch(e){
      rethrow;
    }
  }
}
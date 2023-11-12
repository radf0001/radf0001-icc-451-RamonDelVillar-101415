import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

import '../model/pokemon_data.dart';

// ignore: constant_identifier_names
const BASE_API_URL = "https://pokeapi.co/api/v2/pokemon?limit=1292";

class ApiService {

  static Future getPokemons() async {
    try{
      final response = await http.get(Uri.parse(BASE_API_URL));

      if(response.statusCode == 200){
        var result = pokemonsDataFromJson(response.body);
        return result.results;
      }
    }catch (e){
      return null;
    }

  }
}

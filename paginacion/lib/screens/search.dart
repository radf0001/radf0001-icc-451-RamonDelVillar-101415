import 'package:flutter/material.dart';
import 'package:paginacion/model/pokemon_data.dart';
import 'package:http/http.dart' as http;
import '../db/db_helper.dart';
import 'DetallePokemon.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pokedex",
            style: TextStyle(color: Colors.yellow, fontFamily: 'PokemonHollow'),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        body: const SearchPage(),
        backgroundColor: Colors.grey[800]);
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  final TextEditingController _searchTextController = TextEditingController();
  List<PokemonDb> _pokemons = [];

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(() async {
      _pokemons = await dbHelper.searchPokemons(_searchTextController.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 60.0,
            padding: const EdgeInsets.only(left: 20, top: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              controller: _searchTextController,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
          ),
          ..._pokemons.map((PokemonDb m) {
            return MaisonCard(pokemon: m, context: context);
          }).toList(),
        ],
      ),
    );
  }
}

Widget MaisonCard({required PokemonDb pokemon, required BuildContext context}) {
  dynamic pokemonDetails;

  Future<bool> fetchPokemonDetails(String pokemonNumber) async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonNumber'));
    if (response.statusCode == 200) {
      final result = pokemonFromJson(response.body);
      pokemonDetails = result;
      return true;
    } else {
      return false;
    }
  }

  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () async {
            await fetchPokemonDetails(pokemon.idName!.split(' ')[0]);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetallePokemon(
                  pokemonNumber: pokemon.idName!.split(' ')[0],
                  pokemonName: pokemon.idName!.split(' ')[1],
                  pokemonDetails: pokemonDetails,
                ),
              ),
            );
          },
          title: Text('${pokemon.idName}'),
        ),
      ],
    ),
  );
}

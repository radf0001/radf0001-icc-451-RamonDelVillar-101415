import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:personalizado/screens/search_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../services/pokemon_favorite.dart';
import '../widget/pokemon_card_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final pokemonFavoriteService = PokemonFavoritesController();
  ScrollController scrollController = ScrollController();
  int limit = 76;
  String next = "https://pokeapi.co/api/v2/pokemon?limit=76";
  String type = "";
  List<dynamic> pokemonsResult = [];
  bool isFavorite = false;
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> getPokemonData({bool isRefresh = false, String filter = "all"}) async{
    if(isFavorite){
      if(isRefresh) {
        pokemonsResult = [];
        List<dynamic> temp = await pokemonFavoriteService.jsonGetFavoritePokemonsData();
        if(filter != "all"){
          Uri uri = Uri.parse("https://pokeapi.co/api/v2/type/$filter");
          final response = await http.get(uri);
          if(response.statusCode == 200){
            final dynamic result;
            result = json.decode(response.body);
            // print(pokemonsResult);
            // print(result["pokemon"]);
            // Extraer nombres y URL de ambas listas
            if(temp.isNotEmpty && result["pokemon"].isNotEmpty){
              // Convertir listas a conjuntos de mapas
              Set setLista1 = temp.map((e) => '${e['name']} ${e['url']}').toSet();
              Set setLista2 = result["pokemon"].map((e) => '${e['pokemon']['name']} ${e['pokemon']['url']}').toSet();
              // Encontrar elementos comunes
              var elementosComunes = setLista1.intersection(setLista2);

              // load favorite pokemons data from shared pref
              for (String aux in elementosComunes) {
                pokemonsResult.add({
                  'name': aux.split(' ')[0],
                  'url': aux.split(' ')[1],
                });
              }
            }
          }else{
            return false;
          }
        }else{
          pokemonsResult = temp;
        }
        if(pokemonsResult.isEmpty){
          refreshController.loadNoData();
        }
        setState(() {
        });
        return true;
      }else{
        refreshController.loadNoData();
        return false;
      }
    }else{
      if(isRefresh && filter == "all"){
        next = "https://pokeapi.co/api/v2/pokemon?limit=$limit";
        refreshController.loadComplete();
        pokemonsResult = [];
      }else if(isRefresh && filter != "all"){
        type = "https://pokeapi.co/api/v2/type/$filter";
        pokemonsResult = [];
      }else{
        if(next.isEmpty || filter != "all"){
          refreshController.loadNoData();
          return false;
        }
      }

      final Uri uri;
      if(filter == "all"){
        uri = Uri.parse(next);
      }else{
        uri = Uri.parse(type);
      }
      final response = await http.get(uri);

      if(response.statusCode == 200){
        final dynamic result;
        if(filter == "all"){
          result = json.decode(response.body);
          pokemonsResult += result['results'];
        }else{
          result = json.decode(response.body);
          pokemonsResult += result['pokemon'];
          if(pokemonsResult.isEmpty){
            refreshController.loadNoData();
          }
        }

        if(filter == "all"){
          if(result['next'] != null){
            next = result['next'];
          } else {
            next="";
          }
        }
        setState(() {
        });
        return true;
      }else{
        return false;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? valueChoose="all";
  List<String> pokemonTypes = [
    "all",
    "normal",
    "fighting",
    "flying",
    "poison",
    "ground",
    "rock",
    "bug",
    "ghost",
    "steel",
    "fire",
    "water",
    "grass",
    "electric",
    "psychic",
    "ice",
    "dragon",
    "dark",
    "fairy",
    "unknown",
    "shadow",
  ];
  dynamic result = "";
  dynamic pokemonResult = "";

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        title:
        Row(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: valueChoose,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
                onChanged: (newValue) {
                  // await getPokemonData(isRefresh: true, filter: newValue!);
                  setState(() {
                    valueChoose = newValue;
                    refreshController.requestRefresh(needMove: false);
                  });
                },
                items: pokemonTypes.map((valueItem) {
                  if(valueItem == valueChoose){
                    return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem, style: const TextStyle(color: Colors.white, fontFamily: "PokemonSolid", backgroundColor: Colors.black))
                    );
                  }
                  else{
                    return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem, style: const TextStyle(color: Colors.black, fontFamily: "PokemonSolid"))
                    );
                  }
                }).toList(),
              ),
            ),
            const Spacer(),
            const Text("Pokedex",
              style: TextStyle(color: Colors.yellowAccent, fontFamily: 'PokemonHollow'),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                refreshController.requestRefresh(needMove: false);
              });
            },
            icon: const Icon(Icons.favorite),
            color: isFavorite ? Colors.pinkAccent : Colors.white,
          ),
          IconButton(
            onPressed: () {
              scrollController.animateTo( //go to top of scroll
                  0,  //scroll offset to go
                  duration: const Duration(milliseconds: 500), //duration of scroll
                  curve:Curves.fastOutSlowIn //scroll type
              );
            },
            icon: const Icon(Icons.vertical_align_top),
            color: Colors.white,
          ),
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
      ),
      body: OrientationBuilder(
        builder: (context, orientation){
          return SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            onRefresh: ()async{
              result = await getPokemonData(isRefresh: true, filter: valueChoose!);
              if(result){
                refreshController.refreshCompleted();
              }else{
                refreshController.refreshFailed();
              }
            },
            onLoading: ()async{
              result = await getPokemonData(filter: valueChoose!);
              if(result){
                refreshController.loadComplete();
              } else if(next.isNotEmpty && valueChoose == "all" && !isFavorite){
                refreshController.loadFailed();
              }
            },
            child: GridView.builder(
              // addAutomaticKeepAlives: true,
              controller: scrollController,
              itemCount: pokemonsResult.length,
              itemBuilder: (context, index){
                if(valueChoose == "all" || isFavorite){
                  pokemonResult = pokemonsResult[index];
                }else{
                  pokemonResult = pokemonsResult[index]['pokemon'];
                }
                return PokemonCardItem(pokemonResult: pokemonResult, index: index);
              },
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // maximum size of item (on small screens 1 item per row, on bigger as many as can fit with 200.0 px width)
                  childAspectRatio: 9/14
              ),
            ),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
    );
  }
}
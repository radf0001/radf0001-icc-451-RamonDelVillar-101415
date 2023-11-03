import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:paginacion/model/pokemon_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 1));
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  int limit = 76;
  String next = "https://pokeapi.co/api/v2/pokemon?limit=76";
  String type = "";
  List<dynamic> pokemonsResult = [];
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> getPokemonData({bool isRefresh = false, String filter = "all"}) async{

    if(isRefresh && filter == "all"){
      next = "https://pokeapi.co/api/v2/pokemon?limit=$limit";
      refreshController.loadComplete();
      pokemonsResult = [];
    }else if(isRefresh && filter != "all"){
      type = "https://pokeapi.co/api/v2/type/$filter";
      refreshController.loadComplete();
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
        result = pokemonsDataFromJson(response.body);
        pokemonsResult += result.results!;
      }else{
        result = pokemonsTypeFromJson(response.body);
        pokemonsResult += result.pokemon!;
        if(pokemonsResult.isEmpty){
          refreshController.loadNoData();
        }
      }

      if(filter == "all"){
        if(result.next != null){
          next = result.next;
        }else{
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
                onChanged: (newValue){
                  setState(() {
                    valueChoose = newValue;
                    getPokemonData(isRefresh: true, filter: valueChoose!);
                  });
                },
                items: pokemonTypes.map((valueItem) {
                  if(valueItem == valueChoose){
                    return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem, style: TextStyle(color: Colors.white, fontFamily: "PokemonSolid", backgroundColor: Colors.grey[900]))
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
            const SizedBox(width: 38.7),
            const Text("Pokedex",
              style: TextStyle(color: Colors.yellow, fontFamily: 'PokemonHollow'),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
        backgroundColor: Colors.grey[900],
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: ()async{
          final result = await getPokemonData(isRefresh: true, filter: valueChoose!);
          if(result){
            refreshController.refreshCompleted();
          }else{
            refreshController.refreshFailed();
          }
        },
        onLoading: ()async{
          final result = await getPokemonData(filter: valueChoose!);
          if(result){
            refreshController.loadComplete();
          } else if(next.isNotEmpty && valueChoose == "all"){
            refreshController.loadFailed();
          }
        },
        child: MasonryGridView.builder(
          // addAutomaticKeepAlives: true,
          itemBuilder: (context, index){
            final background = index.isEven ? Colors.redAccent : Colors.blueAccent;
            List<Color> gradient = [
              background,
              background,
              Colors.white,
              Colors.white,
            ];
            final dynamic pokemonResult;
            if(valueChoose == "all"){
              pokemonResult = pokemonsResult[index];
            }else{
              pokemonResult = pokemonsResult[index].pokemon;
            }
            final id = pokemonResult.url.split('/')[6];
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: gradient,
                    stops: const [0.0, 0.5, 0.5, 1.0],
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text("${id.toString().padLeft(5, '0')} ",
                          style: const TextStyle(color: Colors.white, fontFamily: 'PokemonSolid'),
                        )
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 3,
                          decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.black),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white),
                        ),
                        index.isEven ? SvgPicture.asset("lib/images/redPokeBall.svg") : SvgPicture.asset("lib/images/bluePokeball.svg"),
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: FastCachedImage(
                            url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(seconds: 0),
                            errorBuilder: (context, exception, stacktrace) {
                              return FastCachedImage(
                                url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png",
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(seconds: 0),
                                errorBuilder: (context, exception, stacktrace) {
                                  return const Text("");
                                },
                                loadingBuilder: (context, progress) {
                                  return const Text("");
                                },
                              );
                            },
                            loadingBuilder: (context, progress) {
                              return const Text("");
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${pokemonResult.name}",
                          style: const TextStyle(color: Colors.black, fontFamily: 'PokemonSolid'),
                        )
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: pokemonsResult.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
        ),
      ),
      backgroundColor: Colors.grey[800],
    );
  }
}
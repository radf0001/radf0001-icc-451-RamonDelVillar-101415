import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// ignore: unused_import
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:paginacion/api/http_request.dart';
import 'package:paginacion/model/pokemon_data.dart';
// ignore: unused_import
import 'package:paginacion/screens/DetallePokemon.dart';
import 'package:paginacion/screens/search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'db/db_helper.dart';
import 'screens/ProductgridItemWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 1));
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Define el tamaño de diseño aquí
      builder: (BuildContext context, Widget? child) {
        // Inicializar ScreenUtil en este punto
        return MaterialApp(
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int limit = 76;
  String next = "https://pokeapi.co/api/v2/pokemon?limit=76";
  String type = "";
  List<dynamic> pokemonsResult = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  dynamic pokemonDetails;

  Future<Pokemon> fetchPokemonDetails(int pokemonNumber) async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonNumber'));

    if (response.statusCode == 200) {
      return pokemonFromJson(response.body);
    } else {
      // Maneja el caso de error aquí. Podrías lanzar una excepción o devolver un Pokémon vacío/dummy.
      throw Exception('Failed to load pokemon data');
    }
  }

  Future<bool> getPokemonData(
      {bool isRefresh = false, String filter = "all"}) async {
    if (isRefresh && filter == "all") {
      next = "https://pokeapi.co/api/v2/pokemon?limit=$limit";
      refreshController.loadComplete();
      pokemonsResult = [];
    } else if (isRefresh && filter != "all") {
      type = "https://pokeapi.co/api/v2/type/$filter";
      pokemonsResult = [];
    } else {
      if (next.isEmpty || filter != "all") {
        refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri;
    if (filter == "all") {
      uri = Uri.parse(next);
    } else {
      uri = Uri.parse(type);
    }
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic result;
      if (filter == "all") {
        result = pokemonsDataFromJson(response.body);
        pokemonsResult += result.results!;
      } else {
        result = pokemonsTypeFromJson(response.body);
        pokemonsResult += result.pokemon!;
        if (pokemonsResult.isEmpty) {
          refreshController.loadNoData();
        }
      }

      if (filter == "all") {
        if (result.next != null) {
          next = result.next;
        } else {
          next = "";
        }
      }
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  void addDataToDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.getCountData();
    if (count! != 1292) {
      ApiService.getPokemons().then((value) async {
        if (value != null) {
          for (Result m in value) {
            await dbHelper.insertData(
                PokemonDb(idName: "${m.url.split('/')[6]} ${m.name}"));
          }
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addDataToDatabase();
  }

  String? valueChoose = "all";
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
  dynamic background = "";
  dynamic pokemonResult = "";
  dynamic id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: valueChoose,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                onChanged: (newValue) {
                  refreshController.requestRefresh(needMove: false);
                  setState(() {
                    valueChoose = newValue;
                  });
                },
                items: pokemonTypes.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(
                      valueItem,
                      style: TextStyle(
                        color: valueItem == valueChoose
                            ? Colors.white
                            : Colors.black,
                        fontFamily: "PokemonSolid",
                        backgroundColor: valueItem == valueChoose
                            ? Colors.grey[900]
                            : Colors.transparent,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 38.7),
            const Text(
              "Pokedex",
              style:
                  TextStyle(color: Colors.yellow, fontFamily: 'PokemonHollow'),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MySearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
        backgroundColor: Colors.grey[900],
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          bool result =
              await getPokemonData(isRefresh: true, filter: valueChoose!);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          bool result = await getPokemonData(filter: valueChoose!);
          if (result) {
            refreshController.loadComplete();
          } else if (next.isNotEmpty && valueChoose == "all") {
            refreshController.loadFailed();
          }
        },
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            final dynamic pokemonResult = valueChoose == "all"
                ? pokemonsResult[index]
                : pokemonsResult[index].pokemon;
            final String id = pokemonResult.url.split('/')[6];
            return ProductgridItemWidget(
              pokemonName: pokemonResult.name,
              pokemonNumber: int.parse(id),
              getDetailsAndNavigate: fetchPokemonDetails,
            );
          },
          itemCount: pokemonsResult.length,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // super.build(context);
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Row(
  //         children: [
  //           DropdownButtonHideUnderline(
  //             child: DropdownButton<String>(
  //               value: valueChoose,
  //               icon: const Icon(
  //                 Icons.arrow_drop_down,
  //                 color: Colors.white,
  //               ),
  //               onChanged: (newValue) {
  //                 // await getPokemonData(isRefresh: true, filter: newValue!);
  //                 refreshController.requestRefresh(needMove: false);
  //                 setState(() {
  //                   valueChoose = newValue;
  //                 });
  //               },
  //               items: pokemonTypes.map((valueItem) {
  //                 if (valueItem == valueChoose) {
  //                   return DropdownMenuItem(
  //                       value: valueItem,
  //                       child: Text(valueItem,
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontFamily: "PokemonSolid",
  //                               backgroundColor: Colors.grey[900])));
  //                 } else {
  //                   return DropdownMenuItem(
  //                       value: valueItem,
  //                       child: Text(valueItem,
  //                           style: const TextStyle(
  //                               color: Colors.black,
  //                               fontFamily: "PokemonSolid")));
  //                 }
  //               }).toList(),
  //             ),
  //           ),
  //           const SizedBox(width: 38.7),
  //           const Text(
  //             "Pokedex",
  //             style:
  //                 TextStyle(color: Colors.yellow, fontFamily: 'PokemonHollow'),
  //           ),
  //         ],
  //       ),
  //       centerTitle: true,
  //       actions: <Widget>[
  //         IconButton(
  //           onPressed: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const MySearchPage(),
  //                 ));
  //           },
  //           icon: const Icon(Icons.search),
  //           color: Colors.white,
  //         )
  //       ],
  //       backgroundColor: Colors.grey[900],
  //     ),
  //     body: SmartRefresher(
  //       controller: refreshController,
  //       enablePullUp: true,
  //       onRefresh: () async {
  //         result = await getPokemonData(isRefresh: true, filter: valueChoose!);
  //         if (result) {
  //           refreshController.refreshCompleted();
  //         } else {
  //           refreshController.refreshFailed();
  //         }
  //       },
  //       onLoading: () async {
  //         result = await getPokemonData(filter: valueChoose!);
  //         if (result) {
  //           refreshController.loadComplete();
  //         } else if (next.isNotEmpty && valueChoose == "all") {
  //           refreshController.loadFailed();
  //         }
  //       },
  //       child: MasonryGridView.builder(
  //         // addAutomaticKeepAlives: true,
  //         itemBuilder: (context, index) {
  //           background = index.isEven ? Colors.redAccent : Colors.blueAccent;
  //           List<Color> gradient = [
  //             background,
  //             background,
  //             Colors.white,
  //             Colors.white,
  //           ];
  //           if (valueChoose == "all") {
  //             pokemonResult = pokemonsResult[index];
  //           } else {
  //             pokemonResult = pokemonsResult[index].pokemon;
  //           }
  //           id = pokemonResult.url.split('/')[6];
  //           return Padding(
  //             key: Key(id),
  //             padding: const EdgeInsets.all(5.0),
  //             child: InkWell(
  //               onTap: () async {
  //                 valueChoose == "all"
  //                     ? await fetchPokemonDetails(
  //                         pokemonsResult[index].url.split('/')[6])
  //                     : await fetchPokemonDetails(
  //                         pokemonsResult[index].pokemon.url.split('/')[6]);
  //                 Navigator.of(context).push(
  //                   MaterialPageRoute(
  //                     builder: (context) => valueChoose == "all"
  //                         ? DetallePokemon(
  //                             pokemonNumber:
  //                                 pokemonsResult[index].url.split('/')[6],
  //                             pokemonName: pokemonsResult[index].name,
  //                             pokemonDetails: pokemonDetails,
  //                           )
  //                         : DetallePokemon(
  //                             pokemonNumber: pokemonsResult[index]
  //                                 .pokemon
  //                                 .url
  //                                 .split('/')[6],
  //                             pokemonName: pokemonsResult[index].pokemon.name,
  //                             pokemonDetails: pokemonDetails,
  //                           ),
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 height: 250,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5),
  //                   gradient: LinearGradient(
  //                     colors: gradient,
  //                     stops: const [0.0, 0.5, 0.5, 1.0],
  //                     end: Alignment.bottomCenter,
  //                     begin: Alignment.topCenter,
  //                   ),
  //                 ),
  //                 child: Stack(
  //                   alignment: AlignmentDirectional.center,
  //                   children: [
  //                     Container(
  //                       height: 3,
  //                       decoration: const BoxDecoration(
  //                           shape: BoxShape.rectangle, color: Colors.black),
  //                     ),
  //                     Container(
  //                       width: 60,
  //                       height: 60,
  //                       decoration: const BoxDecoration(
  //                           shape: BoxShape.circle, color: Colors.black),
  //                     ),
  //                     Container(
  //                       width: 50,
  //                       height: 50,
  //                       decoration: const BoxDecoration(
  //                           shape: BoxShape.circle, color: Colors.white),
  //                     ),
  //                     index.isEven
  //                         ? SvgPicture.asset("lib/images/redPokeBall.svg")
  //                         : SvgPicture.asset("lib/images/bluePokeball.svg"),
  //                     SizedBox(
  //                       width: 150,
  //                       height: 150,
  //                       child: FastCachedImage(
  //                         url:
  //                             "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png",
  //                         fit: BoxFit.cover,
  //                         fadeInDuration: const Duration(seconds: 0),
  //                         errorBuilder: (context, exception, stacktrace) {
  //                           return FastCachedImage(
  //                             url:
  //                                 "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png",
  //                             fit: BoxFit.cover,
  //                             fadeInDuration: const Duration(seconds: 0),
  //                             errorBuilder: (context, exception, stacktrace) {
  //                               return FastCachedImage(
  //                                 url:
  //                                     "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
  //                                 fit: BoxFit.cover,
  //                                 fadeInDuration: const Duration(seconds: 0),
  //                                 errorBuilder:
  //                                     (context, exception, stacktrace) {
  //                                   return const Text("");
  //                                 },
  //                                 loadingBuilder: (context, progress) {
  //                                   return const Text("");
  //                                 },
  //                               );
  //                             },
  //                             loadingBuilder: (context, progress) {
  //                               return const Text("");
  //                             },
  //                           );
  //                         },
  //                         loadingBuilder: (context, progress) {
  //                           return const Text("");
  //                         },
  //                       ),
  //                     ),
  //                     Positioned(
  //                       top: 0,
  //                       right: 8,
  //                       child: Text(
  //                         id.toString().padLeft(5, '0'),
  //                         style: const TextStyle(
  //                             color: Colors.white, fontFamily: 'PokemonSolid'),
  //                       ),
  //                     ),
  //                     Positioned(
  //                         bottom: 0,
  //                         left: 8,
  //                         child: SizedBox(
  //                           width: 185,
  //                           child: Text(
  //                             pokemonResult.name,
  //                             style: const TextStyle(
  //                                 color: Colors.black,
  //                                 fontFamily: 'PokemonSolid'),
  //                           ),
  //                         ))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //         itemCount: pokemonsResult.length,
  //         gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2),
  //       ),
  //     ),
  //     backgroundColor: Colors.grey[800],
  //   );
  // }
}

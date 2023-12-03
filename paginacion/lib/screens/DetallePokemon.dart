import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:paginacion/core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:paginacion/db/db_helper.dart';
import 'package:paginacion/main.dart';
import 'package:paginacion/screens/Favoritos.dart';
import 'dart:convert';
import '../model/pokemon_data.dart';
import 'package:paginacion/model/FavoritePokemon.dart';

class DetallePokemon extends StatelessWidget {
  final String pokemonNumber;
  final String pokemonName;
  final Pokemon pokemonDetails;

  const DetallePokemon(
      {Key? key,
      required this.pokemonNumber,
      required this.pokemonName,
      required this.pokemonDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => Scaffold(
                body: CardInterface(
                    pokemonNumber: pokemonNumber,
                    pokemonName: pokemonName,
                    pokemonDetails: pokemonDetails),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () => navigateToHome(context),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () => navigateToFavorites(context),
                      ),
                    ],
                  ),
                ),
              ),
        },
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  void navigateToFavorites(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(),
      ),
    );
  }
}

class CardInterface extends StatefulWidget {
  final String pokemonNumber;
  final String pokemonName;
  final Pokemon pokemonDetails;

  const CardInterface({
    Key? key,
    required this.pokemonNumber,
    required this.pokemonName,
    required this.pokemonDetails,
  }) : super(key: key);

  @override
  _CardInterfaceState createState() => _CardInterfaceState();
}

enum DetalleTab { estadisticas, movimientos, habilidades }

class _CardInterfaceState extends State<CardInterface>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Métodos para obtener los movimientos y habilidades del Pokemon
  // Estos métodos deberían obtener datos de la API o de tu modelo de datos
  Future<List<String>> fetchMovements() async {
    // Aquí iría la lógica para obtener los movimientos de la API
    // y devolver una lista de strings representando los movimientos
    return ["Movimiento 1", "Movimiento 2"]; // Datos de ejemplo
  }

  Future<List<String>> fetchAbilities() async {
    // Aquí iría la lógica para obtener las habilidades de la API
    // y devolver una lista de strings representando las habilidades
    return ["Habilidad 1", "Habilidad 2"]; // Datos de ejemplo
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String speciesUrl = widget.pokemonDetails.species.url;
    return FutureBuilder<int>(
      future: fetchEvolutionChainId(speciesUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          return buildScrollView(snapshot.data!);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<int> fetchEvolutionChainId(String speciesUrl) async {
    var response = await http.get(Uri.parse(speciesUrl));
    var json = jsonDecode(response.body);
    var evolutionChainUrl = json['evolution_chain']['url'] as String;

    // Obtiene la última parte de la URL y elimina cualquier caracter no deseado
    var evolutionChainIdString =
        evolutionChainUrl.split('/').where((s) => s.isNotEmpty).last;

    // Intenta convertir la cadena a un número entero
    try {
      return int.parse(evolutionChainIdString);
    } catch (e) {
      throw FormatException(
          "No se pudo convertir la URL de la cadena de evolución a un ID numérico.");
    }
  }

  Widget buildScrollView(int evolutionChainId) {
    final pokemonDetails = widget.pokemonDetails;
    // Obtén el tamaño de la pantalla
    var screenSize = MediaQuery.of(context).size;
    // Obtiene el primer tipo de Pokémon para usar como fondo.
    // Asegúrate de que pokemonDetails.types.first sea un objeto con una propiedad `name`.
    String type = pokemonDetails.types?.isNotEmpty ?? false
        ? pokemonDetails.types!.first.type!.name
        : 'default';
    String backgroundImage = getBackgroundImage(type);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset(
                      backgroundImage,
                      fit: BoxFit.cover,
                      height: screenSize.height * 0.3,
                      width: screenSize.width,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),

                    // Opacity(
                    //   opacity: 0.7, // Ajusta tu valor de opacidad (0.0 - 1.0)
                    //   child: Image.asset(
                    //     backgroundImage,
                    //     fit: BoxFit.cover,
                    //     height: screenSize.height * 0.3,
                    //     width: screenSize.width,
                    //     colorBlendMode: BlendMode.darken,
                    //   ),
                    // ),
                    Positioned(
                      top: ScreenUtil().statusBarHeight +
                          10, // Ajusta esta línea si es necesario para el espaciado
                      left: 0,
                      right:
                          0, // Establece los lados izquierdo y derecho a 0 para centrar horizontalmente
                      child: Center(
                        // Asegúrate de que el texto esté centrado horizontalmente
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#${widget.pokemonNumber}',
                            style: TextStyle(
                              fontSize:
                                  24.sp, // Aumenta el tamaño de la fuente aquí
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: PokemonTypeIcons(
                              // Solo llamamos a map si 'types' no es null, de lo contrario, pasamos una lista vacía.
                              pokemonTypes: pokemonDetails.types
                                      ?.map((t) => t.type!.name)
                                      .toList() ??
                                  [],
                            ),
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {
                                addToFavorites(
                                    pokemonDetails.name,
                                    pokemonDetails.sprites.other
                                        ?.officialArtwork?.frontDefault);
                              },
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          width: double.infinity,
                          child: FastCachedImage(
                            url:
                                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonNumber}.png",
                            fit: BoxFit.contain,
                            height: SizeExtension(200).h,
                            fadeInDuration: const Duration(seconds: 0),
                            errorBuilder: (context, exception, stacktrace) {
                              return FastCachedImage(
                                url:
                                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${widget.pokemonNumber}.png",
                                fit: BoxFit.contain,
                                height: SizeExtension(200).h,
                                fadeInDuration: const Duration(seconds: 0),
                                errorBuilder: (context, exception, stacktrace) {
                                  return FastCachedImage(
                                    url:
                                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemonNumber}.png",
                                    fit: BoxFit.contain,
                                    height: SizeExtension(200).h,
                                    fadeInDuration: const Duration(seconds: 0),
                                    errorBuilder:
                                        (context, exception, stacktrace) {
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
                              );
                            },
                            loadingBuilder: (context, progress) {
                              return const Text("");
                            },
                          ),
                        ),
                        Text(
                          widget.pokemonName,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Espacio después del nombre
                        TabBar(
                          tabs: [
                            Tab(text: 'Estadísticas'),
                            Tab(text: 'Movimientos'),
                            Tab(text: 'Habilidades'),
                          ],
                        ),
                        Container(
                          height: 80
                              .h, // Adjust the height as needed, or use an Expanded widget
                          child: TabBarView(
                            children: [
                              // Your StatsSection widget
                              StatsSection(pokemonDetails: pokemonDetails),
                              // Your MovementsSection widget
                              MovementsSection(pokemonDetails: pokemonDetails),
                              // Your AbilitiesSection widget
                              AbilitiesSection(pokemonDetails: pokemonDetails),
                            ],
                          ),
                        ),
                        Text(
                          'Evoluciones',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        EvolutionSection(
                          evolutionChainId: evolutionChainId,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addToFavorites(String name, String imageUrl) async {
    // Verificar si el Pokémon ya está en favoritos
    bool exists = await DatabaseHelper.instance.isFavoritePokemonExists(name);
    if (!exists) {
      // Si no existe, lo agregamos a favoritos
      var favorite = FavoritePokemon(name: name, imageUrl: imageUrl);
      await DatabaseHelper.instance.insertFavorite(favorite.toMap());
    }
  }

  String getBackgroundImage(String type) {
    switch (type.toLowerCase()) {
      case "normal":
        return "lib/images/normal.png";
      case "fighting":
        return "lib/images/fighting.png";
      case "flying":
        return "lib/images/flying.png";
      case "poison":
        return "lib/images/poison.png";
      case "ground":
        return "lib/images/ground.png";
      case "rock":
        return "lib/images/rock.png";
      case "bug":
        return "lib/images/bug.png";
      case "ghost":
        return "lib/images/ghost.png";
      case "steel":
        return "lib/images/steel.png";
      case "fire":
        return "lib/images/fire.png";
      case "water":
        return "lib/images/water.png";
      case "grass":
        return "lib/images/grass.png";
      case "electric":
        return "lib/images/electric1.png";
      case "psychic":
        return "lib/images/psychic.png";
      case "ice":
        return "lib/images/ice.png";
      case "dragon":
        return "lib/images/dragon.png";
      case "dark":
        return "lib/images/dark.png";
      case "fairy":
        return "lib/images/fairy.png";
      case "unknown":
        return "lib/images/unknown.png";
      case "shadow":
        return "lib/images/shadow.png";
      default:
        return "lib/images/default.png";
    }
  }
}

class MovementsSection extends StatelessWidget {
  final Pokemon pokemonDetails;

  const MovementsSection({Key? key, required this.pokemonDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Asumimos que cada entrada en 'pokemonDetails.moves' es un Map que contiene un Map 'move' con una propiedad 'name'.
    List<String> moveNames = pokemonDetails.moves!
        .map((moveEntry) => moveEntry['move']['name'] as String)
        .toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: moveNames.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              moveNames[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Si tienes más información sobre el movimiento, puedes añadirla aquí.
          ),
        );
      },
    );
  }
}

class AbilitiesSection extends StatelessWidget {
  final Pokemon pokemonDetails;

  const AbilitiesSection({Key? key, required this.pokemonDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: pokemonDetails.abilities!.length,
      itemBuilder: (context, index) {
        var ability = pokemonDetails.abilities![index].ability;
        return Card(
          child: ListTile(
            title: Text(
              ability!.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

class StatsSection extends StatelessWidget {
  final Pokemon pokemonDetails;

  const StatsSection({Key? key, required this.pokemonDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeExtension(12).h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StatColumn(
              title: 'HP', value: pokemonDetails.stats![0].baseStat.toString()),
          StatColumn(
              title: 'Spd',
              value: pokemonDetails.stats![1].baseStat.toString()),
          StatColumn(
              title: 'Def',
              value: pokemonDetails.stats![2].baseStat.toString()),
          StatColumn(
              title: 'Atk',
              value: pokemonDetails.stats![5].baseStat.toString()),
          StatColumn(
              title: 'SP. Atk',
              value: pokemonDetails.stats![3].baseStat.toString()),
          StatColumn(
              title: 'Sp. Def',
              value: pokemonDetails.stats![4].baseStat.toString()),
        ],
      ),
    );
  }
}

class StatColumn extends StatelessWidget {
  final String title;
  final String value;

  StatColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeExtension(4).h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

// class BottomSection extends StatelessWidget {
//   final Function(DetalleTab) onTabTapped;

//   const BottomSection({
//     Key? key,
//     required this.onTabTapped,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: SizeExtension(12).h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.show_chart),
//                 onPressed: () => onTabTapped(DetalleTab.estadisticas),
//               ),
//               Text(
//                 'Estadísticas',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.loop),
//                 onPressed: () => onTabTapped(DetalleTab.movimientos),
//               ),
//               Text(
//                 'Movimientos',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.star),
//                 onPressed: () => onTabTapped(DetalleTab.habilidades),
//               ),
//               Text(
//                 'Habilidades',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class Evolution {
  final String name;
  final String url;
  final int id;

  Evolution({required this.name, required this.url, required this.id});
}

Future<List<Evolution>> fetchEvolutions(int evolutionChainId) async {
  var url =
      Uri.parse('https://pokeapi.co/api/v2/evolution-chain/$evolutionChainId');
  var response = await http.get(url);
  var json = jsonDecode(response.body);

  List<Evolution> evolutions = [];
  _parseEvolutionChain(json['chain'], evolutions);

  return evolutions;
}

void _parseEvolutionChain(
    Map<String, dynamic> chain, List<Evolution> evolutions) {
  if (chain['species'] != null) {
    var speciesUrl = chain['species']['url'];
    var id = int.parse(
        speciesUrl.split('/')[6]); // Extrae el ID del Pokémon de la URL

    evolutions.add(Evolution(
      name: chain['species']['name'],
      url: speciesUrl,
      id: id,
    ));
  }

  if (chain['evolves_to'] != null && chain['evolves_to'].isNotEmpty) {
    for (var nextChain in chain['evolves_to']) {
      _parseEvolutionChain(nextChain, evolutions);
    }
  }
}

class EvolutionSection extends StatelessWidget {
  final int evolutionChainId;

  const EvolutionSection({Key? key, required this.evolutionChainId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Evolution>>(
      future: fetchEvolutions(evolutionChainId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          // Calcula el ancho total de todas las evoluciones para definir el ancho del contenedor
          final double totalWidth = snapshot.data!.length *
              100; // Asume que cada evolución tiene un ancho de 100

          return SizedBox(
            height: 200, // Altura fija para el GridView
            width:
                totalWidth, // Ancho total del GridView basado en la cantidad de elementos
            child: GridView.builder(
              scrollDirection: Axis
                  .horizontal, // Establece la dirección de desplazamiento del GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Solo una fila
                childAspectRatio: 1.0, // La relación de aspecto de los ítems
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var evolution = snapshot.data![index];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FastCachedImage(
                          url:
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evolution.id}.png",
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(seconds: 0),
                          errorBuilder: (context, exception, stacktrace) {
                            return FastCachedImage(
                              url:
                                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${evolution.id}.png",
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(seconds: 0),
                              errorBuilder: (context, exception, stacktrace) {
                                return FastCachedImage(
                                  url:
                                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolution.id}.png",
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(seconds: 0),
                                  errorBuilder:
                                      (context, exception, stacktrace) {
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
                            );
                          },
                          loadingBuilder: (context, progress) {
                            return const Text("");
                          },
                        ),
                      ),
                      Text(evolution.name),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Text("No hay evoluciones");
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<List<Evolution>>(
  //     future: fetchEvolutions(evolutionChainId),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return Text("Error: ${snapshot.error}");
  //       } else if (snapshot.hasData) {
  //         return GridView.builder(
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             childAspectRatio: 1.0,
  //           ),
  //           itemCount: snapshot.data!.length,
  //           itemBuilder: (context, index) {
  //             var evolution = snapshot.data![index];
  //             return Card(
  //               child: Column(
  //                 children: [
  //                   FastCachedImage(
  //                     url:
  //                         "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evolution.id}.png",
  //                     fit: BoxFit.cover,
  //                     fadeInDuration: const Duration(seconds: 0),
  //                     errorBuilder: (context, exception, stacktrace) {
  //                       return FastCachedImage(
  //                         url:
  //                             "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${evolution.id}.png",
  //                         fit: BoxFit.cover,
  //                         fadeInDuration: const Duration(seconds: 0),
  //                         errorBuilder: (context, exception, stacktrace) {
  //                           return FastCachedImage(
  //                             url:
  //                                 "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolution.id}.png",
  //                             fit: BoxFit.cover,
  //                             fadeInDuration: const Duration(seconds: 0),
  //                             errorBuilder: (context, exception, stacktrace) {
  //                               return const Text("");
  //                             },
  //                             loadingBuilder: (context, progress) {
  //                               return const Text("");
  //                             },
  //                           );
  //                         },
  //                         loadingBuilder: (context, progress) {
  //                           return const Text("");
  //                         },
  //                       );
  //                     },
  //                     loadingBuilder: (context, progress) {
  //                       return const Text("");
  //                     },
  //                   ),
  //                   Text(evolution.name),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       } else {
  //         return Text("No hay evoluciones");
  //       }
  //     },
  //   );
  // }
}

class PokemonTypeIcons extends StatelessWidget {
  final List<String> pokemonTypes;

  const PokemonTypeIcons({
    Key? key,
    required this.pokemonTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = 50.w;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pokemonTypes
          .map((type) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Image.asset(
                  'lib/images/types/${getIconName(type)}.png',
                  width: iconSize,
                  height: iconSize,
                ),
              ))
          .toList(),
    );
  }

  String getIconName(String type) {
    // Convierte el tipo a minúsculas y reemplaza caracteres no deseados si los hay
    String formattedType =
        type.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    return formattedType;
  }
}

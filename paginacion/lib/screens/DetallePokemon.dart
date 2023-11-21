import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:paginacion/core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProductgridItemWidget.dart';
import '../model/pokemon_data.dart';

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
        routes: {
          '/': (context) => Scaffold(
                body: CardInterface(
                    pokemonNumber: pokemonNumber,
                    pokemonName: pokemonName,
                    pokemonDetails: pokemonDetails),
                bottomNavigationBar: BottomAppBar(
                    // child: IconButton(
                    //   icon: Icon(Icons.home),
                    //   onPressed: () => navigateToHome(context),
                    // ),
                    ),
              ),
        },
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class CardInterface extends StatelessWidget {
  final String pokemonNumber;
  final String pokemonName;
  final Pokemon pokemonDetails;

  const CardInterface({
    Key? key,
    required this.pokemonNumber,
    required this.pokemonName,
    required this.pokemonDetails,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    String speciesUrl = pokemonDetails.species.url;

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

  Widget buildScrollView(int evolutionChainId) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(
                'https://e1.pxfuel.com/desktop-wallpaper/269/183/desktop-wallpaper-rotom-pokedex-backgrounds-pokedex.jpg',
                fit: BoxFit.cover,
                height: SizeExtension(200).h,
                width: double.infinity,
                colorBlendMode: BlendMode.darken,
              ),
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
                      '#$pokemonNumber',
                      style: TextStyle(
                        fontSize: 24.sp, // Aumenta el tamaño de la fuente aquí
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
                      child: PokemonTypeIcon(
                          pokemonType: pokemonDetails.types![0].type!.name),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    width: double.infinity,
                    child: FastCachedImage(
                      url:
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonNumber.png",
                      fit: BoxFit.contain,
                      height: SizeExtension(200).h,
                      fadeInDuration: const Duration(seconds: 0),
                      errorBuilder: (context, exception, stacktrace) {
                        return FastCachedImage(
                          url:
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonNumber.png",
                          fit: BoxFit.contain,
                          height: SizeExtension(200).h,
                          fadeInDuration: const Duration(seconds: 0),
                          errorBuilder: (context, exception, stacktrace) {
                            return FastCachedImage(
                              url:
                                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png",
                              fit: BoxFit.contain,
                              height: SizeExtension(200).h,
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
                        );
                      },
                      loadingBuilder: (context, progress) {
                        return const Text("");
                      },
                    ),
                  ),
                  SizedBox(
                      height: SizeExtension(12)
                          .h), // Espacio entre la imagen y el nombre
                  Text(
                    pokemonName,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height:
                          SizeExtension(12).h), // Espacio después del nombre
                  StatsSection(
                    pokemonDetails: pokemonDetails,
                  ),
                  SizedBox(
                      height: SizeExtension(12)
                          .h), // Espacio después de las estadísticas
                  BottomSection(),
                  SizedBox(
                      height: SizeExtension(12)
                          .h), // Espacio antes del título "Evoluciones"
                  Text(
                    'Evoluciones',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height: SizeExtension(12)
                          .h), // Espacio después del título "Evoluciones"
                  EvolutionSection(
                    evolutionChainId: evolutionChainId,
                  ),
                  SizedBox(
                      height: SizeExtension(12)
                          .h), // Espacio al final de la pantalla
                ],
              ),
            ],
          ),
        ],
      ),
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

class BottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeExtension(12).h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.show_chart),
                onPressed: () {
                  // Acción al presionar
                },
              ),
              Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.loop),
                onPressed: () {
                  // Acción al presionar
                },
              ),
              Text(
                'Movimientos',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.star),
                onPressed: () {
                  // Acción al presionar
                },
              ),
              Text(
                'Habilidades',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var evolution = snapshot.data![index];
              return Card(
                child: Column(
                  children: [
                    FastCachedImage(
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
                        );
                      },
                      loadingBuilder: (context, progress) {
                        return const Text("");
                      },
                    ),
                    Text(evolution.name),
                  ],
                ),
              );
            },
          );
        } else {
          return Text("No hay evoluciones");
        }
      },
    );
  }
}

class PokemonTypeIcon extends StatelessWidget {
  final String pokemonType;

  const PokemonTypeIcon({
    Key? key,
    required this.pokemonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String iconName = getIconName(pokemonType);
    return Image.asset('lib/images/types/$iconName.png');
  }

  String getIconName(String type) {
    // Convierte el tipo a minúsculas y reemplaza caracteres no deseados si los hay
    String formattedType =
        type.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    return formattedType;
  }
}

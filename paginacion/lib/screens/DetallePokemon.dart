import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:paginacion/core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/pokemon_data.dart';
// void main() {
//   runApp(MyApp());
// }

class DetallePokemon extends StatelessWidget {
  final String pokemonNumber;
  final String pokemonName;
  final Pokemon pokemonDetails;

  const DetallePokemon({Key? key, required this.pokemonNumber, required this.pokemonName, required this.pokemonDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        routes: {
          '/': (context) => Scaffold(
                body: CardInterface(pokemonNumber: pokemonNumber,pokemonName: pokemonName, pokemonDetails: pokemonDetails),
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

  const CardInterface({Key? key, required this.pokemonNumber, required this.pokemonName, required this.pokemonDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      child: PokemonTypeIcon(pokemonType: pokemonDetails.types![0].type!.name),
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
                      url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonNumber.png",
                      fit: BoxFit.contain,
                      height: SizeExtension(200).h,
                      fadeInDuration: const Duration(seconds: 0),
                      errorBuilder: (context, exception, stacktrace) {
                        return FastCachedImage(
                          url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonNumber.png",
                          fit: BoxFit.contain,
                          height: SizeExtension(200).h,
                          fadeInDuration: const Duration(seconds: 0),
                          errorBuilder: (context, exception, stacktrace) {
                            return FastCachedImage(
                              url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png",
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
                  StatsSection(pokemonDetails: pokemonDetails,),
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
                    pokemonName: pokemonName,
                    pokemonImageUrl: "",
                    pokemonNumber: 1,
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
          StatColumn(title: 'HP', value: pokemonDetails.stats![0].baseStat.toString()),
          StatColumn(title: 'Spd', value: pokemonDetails.stats![1].baseStat.toString()),
          StatColumn(title: 'Def', value: pokemonDetails.stats![2].baseStat.toString()),
          StatColumn(title: 'Atk', value: pokemonDetails.stats![5].baseStat.toString()),
          StatColumn(title: 'SP. Atk', value: pokemonDetails.stats![3].baseStat.toString()),
          StatColumn(title: 'Sp. Def', value: pokemonDetails.stats![4].baseStat.toString()),
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

class EvolutionSection extends StatelessWidget {
  final String pokemonName;
  final String pokemonImageUrl;
  final int pokemonNumber;

  const EvolutionSection({
    Key? key,
    required this.pokemonName,
    required this.pokemonImageUrl,
    required this.pokemonNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
      ),
      itemCount: 3, // Número de evoluciones
      itemBuilder: (context, index) {
        // return Card(
        //   child: CustomImageView(
        //     imagePath: ImageConstant.imgGroup95, // Imagen de fondo (pokebola)
        //     height: 60.v,
        //     width: SizeExtension(60).h,
        //     fit: BoxFit.cover,
        //   ),
        // );
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
    String formattedType = type.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    return formattedType;
  }
}

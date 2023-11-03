// import 'package:flutter/material.dart';
// import 'package:palette_generator/palette_generator.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Image Colors',
//       home: HomePage(),
//     );
//   }
// }
//
//
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const ImageColors(
//         image: NetworkImage("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10226.png"),
//         imageSize: Size(256, 160)
//     );
//   }
// }
//
//
// class ImageColors extends StatefulWidget {
//   const ImageColors({super.key, required this.image, required this.imageSize});
//   final ImageProvider image;
//   final Size imageSize;
//
//   @override
//   State<ImageColors> createState() => _ImageColorsState();
// }
//
// class _ImageColorsState extends State<ImageColors> {
//   PaletteGenerator? paletteGenerator;
//   Color defaultColor = Colors.lightBlue;
//
//   void generateColors() async{
//     paletteGenerator = await PaletteGenerator.fromImageProvider(
//       widget.image,
//       size: widget.imageSize,
//       region:
//         Rect.fromLTRB(0, 0, widget.imageSize.width, widget.imageSize.height)
//     );
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     generateColors();
//     return Scaffold(
//       backgroundColor: paletteGenerator != null
//           ? paletteGenerator!.lightVibrantColor != null
//           ? paletteGenerator!.lightVibrantColor!.color : defaultColor : defaultColor,
//       body: Center(
//         child: Image(
//           image: widget.image,
//           width: widget.imageSize.width,
//           height: widget.imageSize.height,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:paginacion/model/pokemon_data.dart';
import 'package:palette_generator/palette_generator.dart';
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

  int limit = 68;
  String next = "https://pokeapi.co/api/v2/pokemon?limit=68";
  List<Result> pokemonsResult = [];
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> getPokemonData({bool isRefresh = false}) async{

    if(isRefresh){
      next = "https://pokeapi.co/api/v2/pokemon?limit=$limit";
      refreshController.loadComplete();
      pokemonsResult = [];
    }else{
      if(next.isEmpty){
        refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri = Uri.parse(next);
    final response = await http.get(uri);

    if(response.statusCode == 200){
      final result = pokemonsDataFromJson(response.body);
      pokemonsResult += result.results!;

      if(result.next != null){
        next = result.next;
      }else{
        next="";
      }
      setState(() {
      });
      return true;
    }else{
      return false;
    }
  }

  String? valueChoose="All";
  List<String> pokemonTypes = [
    "All",
    "Normal",
    "Fighting",
    "Flying",
    "Poison",
    "Ground",
    "Rock",
    "Bug",
    "Ghost",
    "Steel",
    "Fire",
    "Water",
    "Grass",
    "Electric",
    "Psychic",
    "Ice",
    "Dragon",
    "Dark",
    "Fairy",
    "Unknown",
    "Shadow",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Row(
          children: [
            DropdownButton<String>(
              value: valueChoose,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
              onChanged: (newValue){
                setState(() {
                  valueChoose = newValue;
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
          final result = await getPokemonData(isRefresh: true);
          if(result){
            refreshController.refreshCompleted();
          }else{
            refreshController.refreshFailed();
          }
        },
        onLoading: ()async{
          final result = await getPokemonData();
          if(result){
            refreshController.loadComplete();
          } else if(next.isNotEmpty){
            refreshController.loadFailed();
          }
        },
        child: MasonryGridView.builder(
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index){
            final pokemonResult = pokemonsResult[index];
            final id = pokemonResult.url.split('/')[6];
            return ItemGridView(pokemonResult: pokemonResult, id: id);
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

class ItemGridView extends StatefulWidget {
  final Result pokemonResult;
  final String id;
  const ItemGridView({super.key, required this.pokemonResult, required this.id});

  @override
  State<ItemGridView> createState() => _ItemGridViewState();
}

class _ItemGridViewState extends State<ItemGridView> with AutomaticKeepAliveClientMixin {

  PaletteGenerator? paletteGenerator;
  Color defaultColor = Colors.lightBlue;

  void generateColors(ImageProvider image) async{
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        image
    );
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Result pokemonResult = widget.pokemonResult;
    final String id = widget.id;
    try {
      generateColors(FastCachedImageProvider("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png"));
    } on Exception catch (e) {
      print('Unknown exception: $e');
      generateColors(FastCachedImageProvider("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png"));
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: paletteGenerator != null ? paletteGenerator!.lightVibrantColor != null
              ? paletteGenerator!.lightVibrantColor!.color : defaultColor : defaultColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: Text("${id.toString().padLeft(5, '0')} ",
                  style: const TextStyle(color: Colors.white, fontFamily: 'PokemonSolid'),
                )
            ),
            SizedBox(
              height: 150,
              width: 150,
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
                      return const Center(child: Text("POKEMON IMAGE NOT FOUND", style: TextStyle(color: Colors.yellow, fontFamily: 'PokemonHollow')));
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
            Align(
                alignment: Alignment.centerLeft,
                child: Text(" ${pokemonResult.name}",
                  style: const TextStyle(color: Colors.white, fontFamily: 'PokemonSolid'),
                )
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

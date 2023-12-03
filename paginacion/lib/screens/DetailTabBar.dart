// import 'package:flutter/material.dart';
// import 'package:paginacion/model/pokemon_data.dart';
// import 'package:paginacion/screens/DetallePokemon.dart';

// class PokemonDetailTabBar extends StatelessWidget {
//   final Pokemon pokemonDetails;
//   final int evolutionChainId;

//   const PokemonDetailTabBar({
//     Key? key,
//     required this.pokemonDetails,
//     required this.evolutionChainId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Número de pestañas
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           backgroundColor: Colors.white,
//           bottom: TabBar(
//             labelColor: Colors.black,
//             unselectedLabelColor: Color(0xff5f6368),
//             tabs: [
//               Tab(text: "Stats"),
//               Tab(text: "Evolutions"),
//               Tab(text: "Abilities"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             StatsSection(pokemonDetails: pokemonDetails),
//             AbilitiesSection(
//               pokemonDetails: pokemonDetails,
//               abilities: const ["Asdas"],
//             ),
//             MovementsSection(
//               pokemonDetails: pokemonDetails,
//               movements: const ["asd"],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<List<String>> fetchAbilities() async {
//     // Lógica para obtener las habilidades de la API
//     return ["Habilidad 1", "Habilidad 2"]; // Datos de ejemplo
//   }
// }

// class ItemGridView extends StatefulWidget {
//   final Result pokemonResult;
//   final String id;
//   const ItemGridView({super.key, required this.pokemonResult, required this.id});
//
//   @override
//   State<ItemGridView> createState() => _ItemGridViewState();
// }
//
// class _ItemGridViewState extends State<ItemGridView> with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final Result pokemonResult = widget.pokemonResult;
//     final String id = widget.id;
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.lightBlue
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(id.toString().padLeft(5, '0'),
//                   style: const TextStyle(color: Colors.white),
//                 )
//             ),
//             SizedBox(
//               height: 150,
//               width: 150,
//               child: FastCachedImage(
//                 url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
//                 fit: BoxFit.cover,
//                 fadeInDuration: const Duration(seconds: 0),
//                 errorBuilder: (context, exception, stacktrace) {
//                   return const Text("");
//                 },
//                 loadingBuilder: (context, progress) {
//                   return const Text("");
//                 },
//               ),
//             ),
//             Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(pokemonResult.name,
//                   style: const TextStyle(color: Colors.white),
//                 )
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }
import 'package:flutter/material.dart';
import 'package:paginacion/db/db_helper.dart';
import 'package:paginacion/model/FavoritePokemon.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoritePokemon> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    var favoriteData = await DatabaseHelper.instance.getAllFavorites();
    setState(() {
      favorites = favoriteData
          .map((item) => FavoritePokemon(
              id: item['id'], name: item['name'], imageUrl: item['imageUrl']))
          .toList();
    });
  }

  void deleteFavoritePokemon(int id) async {
    await DatabaseHelper.instance.deleteFavorite(id);
    loadFavorites();
  }

  void showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar de Favoritos"),
          content: Text(
              "¿Estás seguro de que deseas eliminar este Pokémon de tus favoritos?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () {
                deleteFavoritePokemon(id);
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: Colors.pink,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1 / 1.2,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final pokemon = favorites[index];
          return GestureDetector(
            onLongPress: () {
              showDeleteConfirmation(context, pokemon.id!);
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            pokemon.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.favorite, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

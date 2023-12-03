import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/pokemon_data.dart';

class DatabaseHelper {
  static const _databaseName = 'PokemonDatabase.db';
  static const int DB_VERSION = 1;

  // DatabaseHelper._();
  // static final DatabaseHelper instance = DatabaseHelper._();

  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await _initDatabase();
  //   return _database!;
  // }

  // Tabla de favoritos
  static const String tableFavorites = 'favorites';

  // Columnas de la tabla favoritos
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnImageUrl = 'imageUrl';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: DB_VERSION, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    // Crea la tabla de pokémon existente
    await db.execute('''
      CREATE TABLE ${PokemonDb.tblPokemon}(
        ${PokemonDb.colNameId} TEXT PRIMARY KEY
      )
    ''');

    // Crea la nueva tabla de favoritos
    await db.execute('''
      CREATE TABLE $tableFavorites (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL
      )
    ''');
  }

  Future<bool> isPokemonExists(String idName) async {
    final db = await database;
    final result = await db.query(
      PokemonDb.tblPokemon,
      where: '${PokemonDb.colNameId} = ?',
      whereArgs: [idName],
    );
    return result.isNotEmpty;
  }

  //Data - insert
  Future<int> insertData(PokemonDb pokemon) async {
    final db = await database;
    bool exists = await isPokemonExists(pokemon.idName!);
    if (!exists) {
      return await db.insert(PokemonDb.tblPokemon, pokemon.toMap());
    }
    return 0; // Retorna 0 o algún otro valor para indicar que no se insertó
  }

  Future<int?> getCountData() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${PokemonDb.tblPokemon}'));
    return count;
  }

  //Data - retrieve all
  Future<List<PokemonDb>> fetchDatas() async {
    Database db = await database;
    List allRows = await db.query(PokemonDb.tblPokemon);
    return allRows.isEmpty
        ? []
        : allRows.map((x) => PokemonDb.fromMap(x)).toList();
  }

  // ignore: body_might_complete_normally_nullable
  Future<int?> closeDb() async {
    var dbClient = await database;
    await dbClient.close();
  }

  deleteAll() async {
    final dbClient = await database;
    dbClient.rawDelete("Delete from ${PokemonDb.tblPokemon}");
  }

  Future<List<PokemonDb>> searchPokemons(String keyword) async {
    if (keyword == "" || keyword == " ") {
      return [];
    }
    Database db = await database;
    List<Map<String, dynamic>> allRows = await db.query(PokemonDb.tblPokemon,
        where: '${PokemonDb.colNameId} LIKE ?', whereArgs: ['%$keyword%']);
    return allRows.isEmpty
        ? []
        : allRows.map((x) => PokemonDb.fromMap(x)).toList();
  }

  // Insertar un nuevo favorito
  Future<int> insertFavorite(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableFavorites, row);
  }

  // Recuperar todos los favoritos
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    Database db = await database;
    return await db.query(tableFavorites);
  }

  // Eliminar un favorito
  Future<int> deleteFavorite(int id) async {
    Database db = await database;
    return await db
        .delete(tableFavorites, where: '$columnId = ?', whereArgs: [id]);
  }

  // Actualizar un favorito
  Future<int> updateFavorite(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db
        .update(tableFavorites, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<bool> isFavoritePokemonExists(String name) async {
    final db = await database;
    final result = await db.query(
      tableFavorites,
      where: '$columnName = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }
}

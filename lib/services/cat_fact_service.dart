import 'package:cat_facts_app/models/fact.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class CatFactService {
  static Database? _db;
  static final CatFactService instance = CatFactService._constructor();

  CatFactService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  final String _factsTableName = 'facts';
  final String _factsDescriptionColumnName = 'description';
  final String _factsFromApiColumnName = 'fromApi';

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'master_db.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_factsTableName (
            id INTEGER PRIMARY KEY,
            $_factsDescriptionColumnName TEXT NOT NULL,
            $_factsFromApiColumnName INTEGER NOT NULL
          )
        ''');
      },
    );

    return database;
  }

  void addFact(String description, int fromApi) async {
    final db = await database;
    await db.insert(_factsTableName, {
      _factsDescriptionColumnName: description,
      _factsFromApiColumnName: fromApi,
    });
  }

  Future<List<Fact>> getFacts() async {
    final db = await database;
    final data = await db.query(_factsTableName, orderBy: 'id DESC');

    List<Fact> facts = data
        .map((e) => Fact(
            id: e['id'] as int,
            fromApi: e['fromApi'] as int,
            description: e['description'] as String))
        .toList();

    return facts;
  }

  void deleteFact(int id) async {
    final db = await database;
    await db.delete(_factsTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<String> fetchCatFact() async {
    final response = await http.get(Uri.parse('https://catfact.ninja/fact'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['fact'];
    } else {
      throw Exception('Failed to load cat fact');
    }
  }
}

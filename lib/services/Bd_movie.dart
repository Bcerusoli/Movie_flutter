import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class Bd_movie {
  static final Bd_movie _instance = Bd_movie._internal();
  factory Bd_movie() => _instance;
  Bd_movie._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY,
        title TEXT,
        year TEXT,
        duration TEXT,
        genre TEXT,
        director TEXT,
        synopsis TEXT,
        imageUrl TEXT,
        rating TEXT
      )
    ''');
  }

  Future<void> insertMovie(Movie movie) async {
    final db = await database;
    await db.insert('movies', movie.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        year: maps[i]['year'],
        duration: maps[i]['duration'],
        genre: maps[i]['genre'],
        director: maps[i]['director'],
        synopsis: maps[i]['synopsis'],
        imageUrl: maps[i]['imageUrl'],
        rating: maps[i]['rating'],
      );
    });
  }

  Future<void> deleteAllMovies() async {
    final db = await database;
    await db.delete('movies');
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'fitness_app_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT,
        health_goals TEXT,
        gender TEXT,
        date_of_birth TEXT,
        weight REAL,
        height REAL
      )
    ''');

    // Tabela de Detalhes do Exercício
    await db.execute('''
      CREATE TABLE exercise_details (
        id INTEGER PRIMARY KEY,
        title TEXT
        -- Adicione outras colunas conforme necessário
      )
    ''');

    // Tabela de Agendamentos
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY,
        date TEXT,
        time TEXT,
        workout_title TEXT,
       workout_exercises TEXT, -- Armazene a lista de exercícios como JSON
      difficulty TEXT,
     repetitions TEXT,
       weights TEXT
        -- Adicione outras colunas conforme necessário
      )
    ''');
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Database db = await database;

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<void> saveUserProfile(
      String gender, String dateOfBirth, double weight, double height) async {
    Database db = await database;

    await db.insert(
      'users',
      {
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'weight': weight,
        'height': height,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertExerciseDetails(
      Map<String, dynamic> exerciseDetails) async {
    Database db = await database;
    return await db.insert('exercise_details', exerciseDetails);
  }

  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    Database db = await database;
    return await db.insert('schedules', schedule);
  }
}

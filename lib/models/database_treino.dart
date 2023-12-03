import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    String path = join(await getDatabasesPath(), 'workout_database_name.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY,
        date TEXT,
        time TEXT,
        workout TEXT,
        difficulty TEXT,
        repetitions TEXT,
        weights TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE exercise_details (
        id INTEGER PRIMARY KEY,
        name TEXT,
        set_name TEXT,
        set_image TEXT,
        set_title TEXT,
        set_value TEXT
      )
    ''');
  }

  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    Database db = await database;
    return await db.insert('schedules', schedule);
  }

  Future<int> insertExerciseDetails(
      Map<String, dynamic> exerciseDetails) async {
    Database db = await database;
    return await db.insert('exercise_details', exerciseDetails);
  }
}

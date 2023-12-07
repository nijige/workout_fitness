import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_app/models/user_model.dart';

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
    String path = join(await getDatabasesPath(), 'workout_database.db');
    return await openDatabase(path,
        version: 6, onCreate: _createDatabase, onUpgrade: _upgradeDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    try {
      // Tabela de Usuários
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          nome TEXT,
          email TEXT,
          health_goals TEXT,
          gender TEXT,
          date_of_birth TEXT,
          weight REAL,
          height REAL,
          password TEXT
        )
      ''');

      // Verificar se a coluna 'password' já existe
      List<Map<String, dynamic>> columns =
          await db.rawQuery("PRAGMA table_info(users);");
      bool passwordColumnExists =
          columns.any((column) => column['name'] == 'password');

      // Se a coluna 'password' não existir, adicione-a
      if (!passwordColumnExists) {
        await db.transaction((txn) async {
          await txn.execute('ALTER TABLE users ADD COLUMN password TEXT;');
          print("Coluna 'password' adicionada.");
        });
      }

      // Tabela de Agendamentos
      await db.execute('''
        CREATE TABLE IF NOT EXISTS schedules (
          id INTEGER PRIMARY KEY,
          date TEXT,
          time TEXT,
          workout TEXT,
          difficulty TEXT,
          repetitions TEXT,
          weights TEXT
        )
      ''');
    } catch (e) {
      print("Erro durante a criação do banco de dados: $e");
    }
  }

  Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 4) {
        // Adicionar a coluna password se não existir
        await db.execute('ALTER TABLE users ADD COLUMN password TEXT;');
      }
    } catch (e) {
      print("Erro durante a atualização do banco de dados: $e");
    }
  }

  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    try {
      Database db = await database;

      // Adicione esta verificação pragma
      List<Map<String, dynamic>> tableInfo =
          await db.rawQuery("PRAGMA table_info(schedules);");
      print("Info da tabela 'schedules': $tableInfo");

      int result = await db.insert('schedules', schedule);
      print("Resultado da inserção: $result");
      return result;
    } catch (e) {
      print("Erro ao inserir agendamento: $e");
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print("Erro ao buscar usuário: $e");
      return null;
    }
  }

  Future<String?> getUserName(int userId) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['nome'],
        where: 'id = ?',
        whereArgs: [userId],
      );

      return result.isNotEmpty ? result.first['nome'] : null;
    } catch (e) {
      print("Erro ao obter nome do usuário: $e");
      return null;
    }
  }

  Future<void> saveUserProfile(
      String gender, String dateOfBirth, double weight, double height) async {
    try {
      Database db = await database;
      await db.insert(
        'users',
        {
          'gender': gender,
          'date_of_birth': dateOfBirth,
          'weight': weight,
          'height': height,
        },
      );
    } catch (e) {
      print("Erro ao salvar perfil do usuário: $e");
    }
  }

  Future<int> insertExerciseDetails(
      Map<String, dynamic> exerciseDetails) async {
    try {
      Database db = await database;
      return await db.insert('exercise_details', exerciseDetails);
    } catch (e) {
      print("Erro ao inserir detalhes do exercício: $e");
      return -1;
    }
  }

  Future<int> getUserId(String email, String password) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['id'],
        where: 'email = ?',
        whereArgs: [email],
      );

      return result.isNotEmpty ? result.first['id'] : -1;
    } catch (e) {
      print("Erro ao obter ID do usuário: $e");
      return -1;
    }
  }

  Future<int> insertUser(UserModel user) async {
    try {
      Database db = await database;
      return await db.insert('users', user.toMap());
    } catch (e) {
      print("Erro ao inserir usuário: $e");
      return -1;
    }
  }

  Future<bool> checkLogin(String email, String password) async {
    try {
      Database db = await database;

      var result = await db.rawQuery(
          'SELECT COUNT(*) FROM users WHERE email = ? AND password = ?',
          [email, password]);
      print("Resultado da consulta: $result");

      return result.isNotEmpty ? result[0]['COUNT(*)'] == 1 : false;
    } catch (e) {
      print("Erro durante o login: $e");
      return false;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'workout_database.db');

      // Fechar todas as conexões ao banco de dados antes de excluí-lo
      await _closeDatabaseConnections(path);

      // Excluir o arquivo do banco de dados
      await File(path).delete();
    } catch (e) {
      print("Erro ao excluir o banco de dados: $e");
    }
  }

  Future<void> _closeDatabaseConnections(String path) async {
    try {
      // Abra uma conexão temporária para liberar todas as outras conexões
      Database tempDb = await openDatabase(path);

      // Execute um comando vazio apenas para liberar outras conexões
      await tempDb.execute("VACUUM");

      // Feche a conexão temporária
      await tempDb.close();
    } catch (e) {
      print("Erro ao fechar conexões ao banco de dados: $e");
    }
  }
}

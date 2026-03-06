import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/registration_model.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService instance = DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'event_registrations.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE registrations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            workshops TEXT NOT NULL,
            modality TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertRegistration(Registration registration) async {
    final db = await database;
    return db.insert('registrations', registration.toMap());
  }

  Future<List<Registration>> getRegistrations() async {
    final db = await database;
    final result = await db.query('registrations', orderBy: 'id DESC');

    return result.map(Registration.fromMap).toList();
  }
}

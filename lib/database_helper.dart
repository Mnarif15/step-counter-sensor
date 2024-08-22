import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static const int _databaseVersion = 1; // Change to the appropriate version

  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

 Future<Database> _initDatabase() async {
  final path = join(await getDatabasesPath(), 'step_counter_database2.db');

  return await openDatabase(path, version: _databaseVersion, onCreate: _createDatabase);
}


  Future<void> _createDatabase(Database db, int version) async {
  await db.execute('''
    CREATE TABLE step_counts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      count INTEGER
    )
  ''');
}

  Future<int> insertStepCount(int count) async {
    final db = await database;
    return await db.insert('step_counts', {'count': count});
  }

 Future<List<int>> queryAllRows() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('step_counts');

  return List.generate(maps.length, (i) {
    return maps[i]['count'];
  });
}

}

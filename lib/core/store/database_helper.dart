import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CharacterDb {
  static final CharacterDb instance = CharacterDb._init();
  static Database? _database;

  CharacterDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rick_morty.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value_int INTEGER,
        value_text TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE characters (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        status TEXT,
        species TEXT,
        location TEXT,
        description TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final db = await database;
    await db.insert('settings', {
      'key': key,
      if (value is int) 'value_int': value,
      if (value is String) 'value_text': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int?> getIntSetting(String key) async {
    final db = await database;
    final res = await db.query('settings', where: 'key = ?', whereArgs: [key]);
    return res.isNotEmpty ? res.first['value_int'] as int? : null;
  }

  Future<void> upsertCharacters(
    List<Map<String, dynamic>> charactersList,
  ) async {
    final db = await database;
    final batch = db.batch();

    for (var charMap in charactersList) {
      batch.insert(
        'characters',
        charMap,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    final db = await database;
    await db.update(
      'characters',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllCharacters() async {
    final db = await database;
    return await db.query('characters');
  }

  Future<List<Map<String, dynamic>>> getFavoriteCharacters() async {
    final db = await database;
    return await db.query(
      'characters',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
  }
}

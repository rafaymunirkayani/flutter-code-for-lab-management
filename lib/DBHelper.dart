import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final _databaseName = "iinventory.db";
  static final _databaseVersion = 1;

  static final tableAdmin = 'admin';
  static final tableUser = 'user';
  static final tableEquipment = 'equipment';
  static final tableIssued = 'issued';

  static final columnUsername = 'username';
  static final columnPassword = 'password';
  static final columnUserId = 'user_id';
  static final columnEquipmentId = 'equipment_id';
  static final columnIssueDate = 'issue_date';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableAdmin (
            $columnUsername TEXT PRIMARY KEY,
            $columnPassword TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableEquipment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            equipment_id TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableIssued (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUsername TEXT NOT NULL,
            $columnEquipmentId TEXT NOT NULL,
            $columnIssueDate TEXT NOT NULL
          )
          ''');
  }

  Future<bool> checkAdminCredentials(String username, String password) async {
    final db = await database;
    final result = await db.query(
      tableAdmin,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<bool> addAdmin(String username, String password) async {
    final db = await database;
    final result = await db.insert(
      tableAdmin,
      {columnUsername: username, columnPassword: password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result > 0;
  }

  Future<bool> addEquipment(String name, String equipmentId) async {
    final db = await database;
    final result = await db.insert(
      tableEquipment,
      {'name': name, 'equipment_id': equipmentId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result > 0;
  }

  Future<List<IssuedEquipment>> getIssuedEquipments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableIssued);
    return List.generate(maps.length, (i) {
      return IssuedEquipment(
        username: maps[i]['username'],
        equipmentId: maps[i]['equipment_id'],
        issueDate: maps[i]['issue_date'],
      );
    });
  }
}

class IssuedEquipment {
  final String username;
  final String equipmentId;
  final String issueDate;

  IssuedEquipment({required this.username, required this.equipmentId, required this.issueDate});
}

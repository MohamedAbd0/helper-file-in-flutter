import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  late Database db;

  final String databaseName = 'myOwn.db';

  ///to open stream connection with db
  Future open(String path) async {
    /*
    NULL. The value is a NULL value.
    INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
    REAL. The value is a floating point value, stored as an 8-byte IEEE floating point number.
    TEXT. The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
    BLOB. The value is a blob of data, stored exactly as it was input.
    */
    const idIntegerType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const idTextType = 'TEXT PRIMARY KEY ';
    const textType = 'TEXT';
    const nullabletextType = 'TEXT ';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER';
    const realType = 'REAL NOT NULL';
    const nullableRealType = 'REAL';
    const fileblob = 'BLOB';
    const nullableIntegerType = 'INTEGER';

    db = await openDatabase(
      path,
      version: 23,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
      onDowngrade: (Database db, int oldVersion, int newVersion) async {},
      onCreate: (Database db, int version) async {
        /// example create table 'info' it contant two colum 'id' and 'details'
        await db.execute('''
          create table info (
            id $idTextType, 
            details $textType
          )
        ''');
      },
    );
  }

  /// to insert json to table
  /// return null if the operation fails otherwise return object id
  Future<dynamic> postJsonData({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    final databasesPath = await getDatabasesPath();
    await open(join(databasesPath, databaseName));
    return db.insert(tableName, data);
  }

  /// to update json data of table by id
  /// return null if the operation fails otherwise return number of changes
  Future<dynamic> putJsonData({
    required String tableName,
    required dynamic id,
    required Map<String, dynamic> data,
  }) async {
    final databasesPath = await getDatabasesPath();
    await open(join(databasesPath, databaseName));
    return db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  /// to get json data from table by id
  Future<List<Map>> getJsonDataByID({
    required String tableName,
    required String filedName,
    required String filedValue,
  }) async {
    final databasesPath = await getDatabasesPath();
    await open(join(databasesPath, databaseName));
    return db.query(
      tableName,
      where: '$filedName = ? ',
      whereArgs: [filedValue],
    );
  }

  /// to remove json data of table by id
  /// return null if the operation fails otherwise return number of changes
  Future<dynamic> removeJsonData({
    required String tableName,
    required dynamic id,
  }) async {
    final databasesPath = await getDatabasesPath();
    await open(join(databasesPath, databaseName));
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearDB(String path) async {
    await deleteDatabase(path);
    await db.close();
  }
}

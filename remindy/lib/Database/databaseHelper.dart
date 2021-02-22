import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:remindy/Models/simpleReminder.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "reminder.db";
  static final _databaseVersion = 1;

  static final table = 'reminders';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnTime = 'time';
  static final columnDescription = 'description';
  static final columnIsDone = 'isDone';
  static final columnRepeat = 'repeat';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}$_databaseName';
    print(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnTime TEXT NOT NULL,
            $columnDescription TEXT,
            $columnIsDone INTEGER,
            $columnRepeat INTEGER
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  queryAllRows() async {
    Database db = await instance.database;
    var result = await db.query(table);
    return (result.isNotEmpty
        ? result.map((c) => Reminder.fromMap(c)).toList()
        : []);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  FutureOr<dynamic> deleteOld(String s) async {
    Database db = await instance.database;

    await db.rawDelete(''' DELETE FROM $table WHERE $columnTime < ? ''', [s]);
  }
}

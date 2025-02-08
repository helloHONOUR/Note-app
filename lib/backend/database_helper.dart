import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._createinstance();

  DatabaseHelper._createinstance();

  factory DatabaseHelper.creatinginstance() {
    return _instance;
  }

// Preparing the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializedatabase();
    return _database!;
  }

  Future<Database> _initializedatabase() async {
    final dbdirectory = await getDatabasesPath();
    final completedirectory = join(dbdirectory, 'notes.db');
    return await openDatabase(
      completedirectory,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo TEXT NOT NULL,
    description TEXT ,
    date TEXT NOT NULL,
    completed INTEGER DEFAULT 0,
    notetime TEXT,
    priority TEXT, 
    tagname TEXT,
    tagcolor TEXT,
    tagicon TEXT
    
  )

''');
        await db.execute('''
      CREATE TABLE IF NOT EXISTS tags (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tagname TEXT NOT NULL,
      tagcolor TEXT NOT NULL,
      tagicon TEXT NOT NULL
    )
      ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Example: Adding a new table called 'new_table'
          await db.execute('''
      CREATE TABLE IF NOT EXISTS tags (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tagname TEXT NOT NULL,
      tagcolor TEXT NOT NULL,
      tagicon TEXT NOT NULL
    )
      ''');
          print("New table 'new_table' created.");
        }

        // Additional upgrade logic for higher versions (if needed)
      },
    );
  }

// CRUD OPERATIONS

// INSERT
  Future<int> inserttodatabase(Map<String, dynamic> maptoinsert) async {
    Database db = await database;
    return db.insert('notes', maptoinsert);
  }

// READFORCOMPLETION
  Future<List<Map<String, dynamic>>> readfromdatabase(completed) async {
    Database db = await database;

    List<Map<String, dynamic>> listofmap = await db.query('notes', where: 'completed = ?', whereArgs: [completed]);

    return listofmap;
  }

// READ WITH DATE
  Future<List<Map<String, dynamic>>> readfromdatabasewithdate(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> listofmap = await db.query('notes', where: 'date = ?', whereArgs: [date]);

    return listofmap;
  }

  // READ WITH ID
  Future<Map<String, dynamic>> readfromdatabasewithID(id) async {
    Database db = await database;

    List<Map<String, dynamic>> listofmap = await db.query('notes', where: 'id = ?', whereArgs: [id]);

    return listofmap[0];
  }

  // GENERALREAD

  Future<List<Map<String, dynamic>>> readfromdbanytime() async {
    Database db = await database;

    List<Map<String, dynamic>> listofmap = await db.query(
      'notes',
    );

    return listofmap;
  }

// UPDATE
  Future<int> updatingtodo(id, String atributetochange, newvalue) async {
    Database db = await database;
    return db.update(
      'notes',
      {atributetochange: newvalue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatingdescription(id, String description) async {
    Database db = await database;
    return db.update(
      'notes',
      {'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatetodatabase(id, update) async {
    Database db = await database;

    return db.update(
      'notes',
      update,
      where: "id = ?",
      whereArgs: [id],
    );
  }

// DELETE
  Future deletefromdatabase(id) async {
    Database db = await database;
    return db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // DELETE DATABASE

  Future deletingdatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    await deleteDatabase(path);
  }

  Future recreatingdatabase() async {
    await deletingdatabase();
    await _initializedatabase();
    print('changed database succefully');
  }

  Future<List<Map>> printTableSchema() async {
    final db = await database;
    final schema = await db.rawQuery('PRAGMA table_info(notes)');
    return schema;
  }

// DATABASE FOR THE TAGS

  Future<int> updatingtags(id, String tagatributetochange, newvalue) async {
    Database db = await database;
    return db.update(
      'tags',
      {tagatributetochange: newvalue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> gettags() async {
    Database db = await database;

    db.getVersion();
    List<Map<String, dynamic>> listoftags = await db.query('tags');
    return listoftags;
  }

  Future<int> inserttags(Map<String, dynamic> newtag) async {
    Database db = await database;
    return db.insert('tags', newtag);
  }

  Future<int> deletingtags(id) async {
    Database db = await database;

    return db.delete(
      'tags',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

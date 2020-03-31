import 'package:flutter/material.dart';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../view/localization.dart';

class FieldType
{
  final int _id;
  static const FieldType TEXT = FieldType._privateConstractor(1);
  static const FieldType NUMBER = FieldType._privateConstractor(2);
  static const FieldType PLACE = FieldType._privateConstractor(3);
  static const FieldType DATETIME = FieldType._privateConstractor(4);

  static const List <FieldType> values = [TEXT, NUMBER, PLACE, DATETIME];
  static const Map _toName = {
    TEXT: 'Text', NUMBER: 'Number', PLACE: 'Place', DATETIME: 'DateTime'
  };
  static Map _toId = {
    'Text': TEXT.id, 'Number': NUMBER.id, 'Place': PLACE.id, 'DateTime': DATETIME.id
  };
  static Map _toLocalizedName;

  const FieldType._privateConstractor(this._id);

  factory FieldType(t){
    switch (t) {
      case TEXT:
      case NUMBER:
      case PLACE:
      case DATETIME:
        return FieldType._privateConstractor(t);
      default:
        return null;
    }
  }

  String toName() {
    return _toName[this];
  }
  static String name2Id(String name) {
    return _toId[name];
  }

  static String toLocalizedName(BuildContext context, FieldType t) {
    if (_toLocalizedName == null) {
      _toLocalizedName = {
        TEXT: MRLocalizations.of(context).fieldTypeText,
        NUMBER: MRLocalizations.of(context).fieldTypeNumber,
        PLACE: MRLocalizations.of(context).fieldTypePlace,
        DATETIME: MRLocalizations.of(context).fieldTypeTime
      };
    }

    return _toLocalizedName[t];
  }

  int get id {
    return _id;
  }
}

class Field {
  String name;
  FieldType type;
  bool must;
  bool decimal;     // Number option
  bool multiline;   // Text option

  Field({
    this.name = '',
    this.must = false,
    this.decimal = false,
    this.multiline = false,
    this.type = FieldType.TEXT,
  });
}

class DataType {
  String name;
  List <Field> fields;
  int tableId;
  DataType(this.name, this.fields, this.tableId);
}

class MRDataManager {
  static final _databaseName = "mem_rec.db";
  static final _databaseVersion = 1;
  static final Logger log = Logger('db');

  // make this a singleton class
  MRDataManager._privateConstructor();
  static final MRDataManager instance = MRDataManager._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  static Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    
    _database = await _initDatabase();
    return _database;
  }
  
  // this opens the database (and creates it if it doesn't exist)
  static _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE tables (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE fields (
            id INTEGER PRIMARY KEY,
            type INTEGER NOT NULL,
            name TEXT NOT NULL,
            must INTEGER NOT NULL,
            multiline INTEGER NOT NULL,
            decimal INTEGER NOT NULL,
            table_id INTEGER NOT NULL,
            FOREIGN KEY(table_id) REFERENCES tables(id)
          )
          ''');
  }
  static Future<DataType> newDataType(String name, List<Field> fields) async {
    Database _db = await database;
    int tableId;
    int ret;
    String sql = '';
    String sqlType;

    await _db.transaction( (txn) async {
      ret = await txn.rawInsert(
        'insert into tables values (?, ?)',
        [null, name]
      );
      print('inserted tables, ret: $ret');
      tableId = Sqflite.firstIntValue(await txn.rawQuery('select last_insert_rowid()'));
      print('table id: $tableId');
      
      for (var f in fields) {
        int must = f.must ? 1 : 0;
        int multiline = f.multiline ? 1 : 0;
        int decimal = f.decimal ? 1 : 0;
        ret = await txn.rawInsert(
          'insert into fields (type, name, must, multiline, decimal, table_id)'
          'values (?, ?, ?, ?, ?, ?)',
          [f.type.id, f.name, must, multiline, decimal, tableId]
        );
        print('inserted fields, ret: $ret');
        switch (f.type) {
          case FieldType.TEXT:
          case FieldType.DATETIME:
          case FieldType.PLACE:
            sqlType = "TEXT";
            break;
            
          case FieldType.NUMBER:
            if (f.decimal) {
              sqlType = "REAL";
            } else {
              sqlType = "INTEGER";
            }
            break;
        }

        if (f.must) {
          sqlType = '$sqlType NOT NULL';
        }
        if (sql.length > 0) sql = '$sql ,';
        sql = '$sql${f.name} $sqlType';
      }
      sql = 'create table table$tableId ($sql)';
      print('create table sql: $sql');
      txn.execute(sql);
    });

    return DataType(name, fields, tableId);
  }
  
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    Database _db = await database;
    return await _db.insert('table', row);
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database _db = await database;
    return await _db.query('table');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static Future<int> queryRowCount() async {
    Database _db = await database;
    return Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM table'));
  }

  // We are assuming here that the id column in the map is set. The other 
  // column values will be used to update the row.
  static Future<int> update(Map<String, dynamic> row) async {
    Database _db = await database;
    int id = 1;
    return await _db.update('table', row, where: 'columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is 
  // returned. This should be 1 as long as the row exists.
  static Future<int> delete(int id) async {
    Database _db = await database;
    return await _db.delete('table', where: 'columnId = ?', whereArgs: [id]);
  }


  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  static void dumpDb() async {
    Database _db = await database;
    List<Map<String, dynamic>> result;

    result = await _db.query('tables');
    print('table count:${result.length}');
    result.forEach((f){
      print("Dump tables:\n");
      print('  name: ${f['name']}, id: ${f['id']}');
    });

    result = await _db.query('fields');
    print('field count:${result.length}');
    result.forEach((f){
      print("Dump fields:\n");
      print('  name: ${f['name']}');
      print('  id  : ${f['id']}');
      print('  must: ${f['must']}');
      print('  multiline: ${f['multiline']}');
      print('  decimal: ${f['decimal']}');
      print('  table_id: ${f['table_id']}');
    });
  }



}
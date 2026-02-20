import 'package:shoesbrand/models/brand.dart';
import 'package:shoesbrand/models/shoe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'shoe_database.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE brands(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    await db.execute(
      'CREATE TABLE shoes(id INTEGER PRIMARY KEY, name TEXT, size1 INTEGER, color INTEGER, brandId INTEGER, FOREIGN KEY (brandId) REFERENCES brands(id) ON DELETE SET NULL)',
    );
  }

  Future<Brand> brand(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('brands', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Brand.fromMap(maps.first);
    } else {
      throw Exception('Brand with id $id not found');
    }
  }

  Future<void> insertBrand(Brand brand) async {
    final db = await database;
    await db.insert('brands', brand.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertShoe(Shoe shoe) async {
    final db = await database;
    await db.insert('shoes', shoe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateShoe(Shoe shoe) async {
    final db = await database;
    await db.update(
      'shoes',
      shoe.toMap(),
      where: 'id = ?',
      whereArgs: [shoe.id],
    );
  }

  Future<List<Brand>> brands() async {
    final db = await database;
    final maps = await db.query('brands');
    return maps.map((map) => Brand.fromMap(map)).toList();
  }

  Future<bool> isBrandNameDuplicate(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('brands', where: 'name = ?', whereArgs: [name]);
    return result.isNotEmpty; // Returns true if a duplicate is found
  }

  Future<List<Shoe>> shoes() async {
    final db = await database;
    final maps = await db.query('shoes');
    return maps.map((map) => Shoe.fromMap(map)).toList();
  }

  Future<void> deleteBrand(int id) async {
    final db = await database;
    await db.delete('brands', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteShoe(int id) async {
    final db = await database;
    await db.delete('shoes', where: 'id = ?', whereArgs: [id]);
  }
}

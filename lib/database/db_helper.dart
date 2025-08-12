// db_helper.dart

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:printapp/models/printer_model.dart';
import 'package:printapp/models/products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            unit TEXT,
            price TEXT,
            productId TEXT,
            isSelected BOOLEAN DEFAULT 0
          );
          
        ''');
        await db.execute('''
          CREATE TABLE printers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            ip TEXT,
            isSelected BOOLEAN DEFAULT 0
          );
        ''');
      },
    );
  }

  static Future<int> insertProduct(Product product) async {
    final dbClient = await db;
    return await dbClient.insert('products', product.toMap());
  }

  static Future<List<Product>> getProducts() async {
    final dbClient = await db;
    final maps = await dbClient.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  static Future<void> clearProducts() async {
    final dbClient = await db;
    await dbClient.delete('products');
  }

  static Future<void> savePrinter(String name, String ip) async {
    final dbClient = await db;
    await dbClient.insert('printers', {
      'name': name,
      'ip': ip,
      'isSelected': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<PrinterModel?> getDefaultPrinter() async {
    final dbClient = await db;
    final result = await dbClient.query('printers', limit: 1);
    if (result.isNotEmpty) {
      return PrinterModel.fromMap(result.first);
    }
    return null;
  }

  static Future<List<PrinterModel>> getSavedPrinter() async {
    final dbClient = await db;
    final result = await dbClient.query('printers');
    return result.map((map) => PrinterModel.fromMap(map)).toList();
  }

  // Get the currently selected printer
  static Future<PrinterModel?> getSelectedPrinter() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'printers',
      where: 'isSelected = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PrinterModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static Future<Product?> getSelectedProduct() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'products',
      where: 'isSelected = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Set a product as selected, unselect others
  static Future<void> selectProduct(Product product) async {
    final dbClient = await _database;
    await dbClient?.update('products', {'isSelected': false}); // Unselect all
    await dbClient?.update(
      'products',
      {'isSelected': 1},
      where: 'id = ?',
      whereArgs: [product.id],
    );
    return;
  }

  static Future<void> loadProductsIfFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;

    if (firstLaunch) {
      await _loadFromCsv();
      await prefs.setBool('firstLaunch', false);
    }
  }

  static Future<void> _loadFromCsv() async {
    final rawCsv = await rootBundle.loadString('assets/barcodePRODUCTS.csv');
    List<List<dynamic>> rows = const CsvToListConverter().convert(
      rawCsv,
      eol: '\n',
    );

    for (var row in rows.skip(1)) {
      if (row.length >= 2) {
        final product = Product(
          name: row[1].toString(),
          productId: row[0].toString(),
          unit: 'pcs',
          price: '00',
          isSelected: false,
        );
        await DBHelper.insertProduct(product);
      }
    }
  }
}

import 'package:intelli_Stock/model/models/inventory_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'smartbiz.db';
  static const _databaseVersion = 1;

  static const table = 'inventoryItems';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnImagePath = 'imagePath';
  static const columnBarcode = 'barcode';
  static const columnPurchasePrice = 'purchasePrice';
  static const columnSalesPrice = 'salesPrice';
  static const columnUnit = 'unit';
  static const columnOpeningStock = 'openingStock';
  static const columnDateTime = 'dateTime';
  static const columnPricePerUnit = 'pricePerUnit';
  static const columnTotalValue = 'totalValue';
  static const columnMinOrderQty = 'minOrderQty';

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS $table(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $columnName TEXT NOT NULL,
      $columnImagePath TEXT,
      $columnBarcode TEXT,
      $columnPurchasePrice REAL,
      $columnSalesPrice REAL,
      $columnUnit TEXT,
      $columnOpeningStock REAL,
      $columnDateTime TEXT,
      $columnPricePerUnit REAL,
      $columnTotalValue REAL,
      $columnMinOrderQty REAL

    )''');
  }

  Future<int> insertItem(InventoryItem item) async {
    final db = await database;
    return await db.insert(table, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT IFNULL(MAX(id+1),0) FROM $table');
    final id = result.first.values.first as int;
    return id;
  }

  Future<InventoryItem> getItem(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: '$columnId=?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InventoryItem.fromMap(maps.first);
    } else {
      throw Exception('Item not found!');
    }
  }

  Future<List<InventoryItem>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return InventoryItem(
          // id: maps[i][columnId],
          name: maps[i][columnName],
          imagePath: maps[i][columnImagePath],
          barcode: maps[i][columnBarcode],
          purchasePrice: maps[i][columnPurchasePrice],
          salesPrice: maps[i][columnSalesPrice],
          unit: maps[i][columnUnit],
          openingStock: maps[i][columnOpeningStock],
          dateTime: maps[i][columnDateTime],
          pricePerUnit: maps[i][columnPricePerUnit],
          totalValue: maps[i][columnTotalValue],
          minOrderQty: maps[i][columnMinOrderQty],
          id: maps[i][columnId]);
    });
  }

  Future<int> updateItem(InventoryItem updatedItem) async {
    try {
      final db = await database;
      final newData = InventoryItem(
          id: updatedItem.id,
          name: updatedItem.name,
          barcode: updatedItem.barcode,
          imagePath: updatedItem.imagePath,
          salesPrice: updatedItem.salesPrice,
          purchasePrice: updatedItem.purchasePrice,
          unit: updatedItem.unit,
          minOrderQty: updatedItem.minOrderQty,
          pricePerUnit: updatedItem.pricePerUnit,
          dateTime: updatedItem.dateTime,
          totalValue: updatedItem.totalValue,
          openingStock: updatedItem.openingStock);
      return await db.update(table, newData.toMap(),
          where: '$columnId=?', whereArgs: [updatedItem.id]);
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<int> deleteItem(int? id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId=?', whereArgs: [id]);
  }
}

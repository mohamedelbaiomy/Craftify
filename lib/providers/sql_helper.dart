// ignore_for_file: avoid_print

import 'package:customers_app_google_play/providers/product_class.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'shopping_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
CREATE TABLE cart_items (
  documentId TEXT PRIMARY KEY,
  name TEXT,
  price DOUBLE,
  qty INTEGER,
  qntty INTEGER,
  imagesUrl TEXT,
  suppId TEXT
)
''');

    batch.execute('''
CREATE TABLE wish_items (
  documentId TEXT PRIMARY KEY,
  name TEXT,
  price DOUBLE,
  qty INTEGER,
  qntty INTEGER,
  imagesUrl TEXT,
  suppId TEXT
)
''');
    batch.commit();

    print('on create was called');
  }

  static Future insertCartItem(Product product) async {
    Database db = await getDatabase;
    await db.insert(
      'cart_items',
      product.toMap(),
    );
    print(await db.query('cart_items'));
  }

  static Future insertWishItem(Product products) async {
    Database db = await getDatabase;
    await db.insert(
      'wish_items',
      products.toMap(),
    );
    print(await db.query('wish_items'));
  }

  static Future<List<Map>> loadCartItems() async {
    Database db = await getDatabase;
    return await db.query('cart_items');
  }

  static Future<List<Map>> loadWishItems() async {
    Database db = await getDatabase;
    return await db.query('wish_items');
  }

  static Future updateItem(Product newProduct, String status) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE cart_items SET qty = ? WHERE documentId = ?', [
      status == 'increment' ? newProduct.qty + 1 : newProduct.qty - 1,
      newProduct.documentId
    ]);
  }

  static Future deleteCartItem(String id) async {
    Database db = await getDatabase;
    await db.delete('cart_items', where: 'documentId = ?', whereArgs: [id]);
  }

  static Future deleteWishItem(String idw) async {
    Database db = await getDatabase;
    await db.delete('wish_items', where: 'documentId = ?', whereArgs: [idw]);
  }

  static Future deleteAllCartItems() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM cart_items');
  }

  static Future deleteAllWishItems() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM wish_items');
  }
}

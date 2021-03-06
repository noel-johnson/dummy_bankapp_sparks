import 'dart:io';
import 'dart:typed_data';

import 'package:bankapp/models/transfers.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankapp/models/customer.dart';

class BankDatabase {
  static final BankDatabase instance = BankDatabase._init();

  static Database? _database;

  BankDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("database.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    var exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {
        throw Exception("Database creation failed at directory check");
      }
      ByteData data = await rootBundle.load(join("assets", "sqlite.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // await db.execute('''
    //   CREATE TABLE $tableCustomer(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, current_balance REAL, date_created INTEGER)
    //   ''');
    await db.execute(
      'CREATE TABLE $tableTransfer(id INTEGER PRIMARY KEY AUTOINCREMENT, sender_name TEXT, receiver_name TEXT, amount REAL, transfer_date TEXT)',
    );
  }

  // Future<Customer> create(Customer customer) async {
  //   final db = await instance.database;
  //   final id = await db.insert(tableCustomer, customer.toMap());
  //   return customer.copy(id: id);
  // }

  Future<Customer> readCustomer(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableCustomer,
        columns: CustomerFields.values,
        where: '${CustomerFields.id}=?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Customer.fromJson(maps.first);
    } else
      throw Exception('ID $id not found');
  }

  Future<List<Customer>> readAllCustomers({int? id}) async {
    final db = await instance.database;
    final orderBy = '${CustomerFields.id} ASC';
    if (id != null) {
      final result = await db.query(tableCustomer,
          orderBy: orderBy, where: '${CustomerFields.id}<>?', whereArgs: [id]);
      return result.map((json) => Customer.fromJson(json)).toList();
    }

    final result = await db.query(tableCustomer, orderBy: orderBy);
    return result.map((json) => Customer.fromJson(json)).toList();
  }

  Future<int> update(Customer customer) async {
    final db = await instance.database;
    return db.update(tableCustomer, customer.toMap(),
        where: '${CustomerFields.id}=?', whereArgs: [customer.id]);
  }

  // Transfer table
  Future<List<Transfers>> readAllTransfers() async {
    final db = await instance.database;
    final orderBy = '${TransferFields.transferDate} DESC';
    final result = await db.query(tableTransfer, orderBy: orderBy);
    return result.map((json) => Transfers.fromJson(json)).toList();
  }

  Future<Transfers> create(Transfers transfer) async {
    final db = await instance.database;
    final id = await db.insert(tableTransfer, transfer.toMap());
    return transfer.copy(id: id);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

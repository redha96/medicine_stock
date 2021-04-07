import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:medicine_stock/model/medicine.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblMedicine = "todo";
  String colId = "id";
  String colTitle = "title";
  String colQuantityOfPackges = "quantityOfPackges";
  String colQuantityOfPills = "quantityOfPills";
  String colDrugPerDay = "drugPerDay";
  String colNumberOfDaysBeforeEndOfStockToNotify =
      "numberOfDaysBeforeEndOfStockToNotify";
  String colDateOfAdd = "dateOfAdd";
  String colDateOfNotification = "dateOfNotification";

  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "drugTest.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblMedicine ($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
            "$colQuantityOfPackges INTGER, $colQuantityOfPills INTGER, $colDrugPerDay INTEGER, $colNumberOfDaysBeforeEndOfStockToNotify INTEGER," +
            "$colDateOfAdd TEXT, $colDateOfNotification TEXT)");
  }

  Future<int> insertMidicine(Medicine medicine) async {
    Database db = await this.db;
    var result = await db.insert(tblMedicine, medicine.toMap());
    return result;
  }

  Future<List> getMidicines() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblMedicine order by $colId ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tblMedicine"),
    );
    return result;
  }

  Future<int> updateMedicine(Medicine medicine) async {
    var db = await this.db;
    var result = await db.update(tblMedicine, medicine.toMap(),
        where: "$colId = ?", whereArgs: [medicine.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    var db = await this.db;
    var result =
        await db.rawDelete('DELETE FROM $tblMedicine WHERE $colId = $id');
    return result;
  }
}

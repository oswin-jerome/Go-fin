import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class FinanceDB {
  static final FinanceDB instance = FinanceDB._init();
  static Database? database_1;
  FinanceDB._init();

  Future<Database> get database async {
    if (database_1 != null) return database_1!;
    database_1 = await _initDatabase("finance.db");
    return database_1!;
  }

  Future<Database> _initDatabase(String dbName) async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(dbPath + "/" + dbName,
        version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int id) async {
    db.execute('''
       CREATE TABLE transactions
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount double DEFAULT 0.0,
  type varchar(50) DEFAULT debit,
  category varchar(50) DEFAULT general,
  upi varchar(255) DEFAULT na,
  account varchar(100) DEFAULT na,
  sms_content binary(255) DEFAULT na,
  date DATE DEFAULT CURRENT_DATE
);
        ''');
  }
}

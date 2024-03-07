import 'package:bcrypt/bcrypt.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:masrafi/models/m_user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

// make a singleton
class DB {
  static final DB instance = DB._init();
  static Database? _database;
  // static List<MCategory>? _categories;
  DB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "main.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(url.join("assets", "main.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }
    // open the database
    var db = await openDatabase(path);

    return db;
  }

  Future<MUser> login(String username, String password) async {
    try {
      final db = await instance.database;
      final List<Map> usersMap =
          await db.rawQuery('SELECT * FROM users WHERE username = "$username"');

      if (usersMap.isNotEmpty) {
        if (BCrypt.checkpw(password, (usersMap[0]['password']))) {
          return MUser(id: usersMap[0]['user_id'], username: username);
        } else {
          return Future.error("كلمة المرور غير صحيحة");
        }
      }
    } on Exception catch (_) {
      return Future.error('هذا المستخدم غير موجود');
    }
    return Future.error('فشل تسجيل الدخول');
  }

  Future<MUser> register(String username, String password) async {
    try {
      final db = await instance.database;
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      await db.transaction((txn) async {
        await txn.execute(
          'INSERT INTO users (username, password) VALUES ("$username", "$hashedPassword")',
        );
      });
      final user = await login(username, password);
      return user;
    } catch (_) {
      return Future.error('فشل التسجيل');
    }
  }

  Future<List<MTransaction>> getTransactions(int userid) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> transactionsMap =
        await db.rawQuery('SELECT * FROM transactions WHERE user_id = $userid');
    print(transactionsMap);
    List<MTransaction> transactions =
        transactionsMap.map((e) => MTransaction.fromMap(e)).toList();
    print(transactions);
    return transactions;
  }

  Future<bool> addTransaction(MTransaction transaction, int userID) async {
    try {
      final db = await instance.database;
      await db.transaction((txn) async {
        txn.execute(
          'INSERT INTO transactions (transaction_name, transaction_amount, transaction_date, user_id, category_id) VALUES ("${transaction.name}", ${transaction.amount}, ${transaction.date.millisecondsSinceEpoch}, $userID, ${transaction.categoryID})',
        );
      });
      return true;
    } on Exception catch (e) {
      return Future.error('Error Inserting new data: $e');
    }
  }

//   Future<List<MCategory>> get getMCategories async {
// if (_categories != null) return Future.value(_categories!);
//     final db = await instance.database;
//     final List<Map> categoriesMap =
//         await db.rawQuery('SELECT * FROM categories');
//     List<MCategory> categories = [];
//     for (var category in categoriesMap) {
//       final MCategory mCategory = MCategory(
//         id: category['category_id'],
//         name: category['category_name'],
//       );
//       categories.add(mCategory);
//     }
//     return categories;
//   }
}

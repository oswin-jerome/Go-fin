import 'package:go_fins/db/finance-db.dart';
import 'package:go_fins/models/transaction.dart' as Trans;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:telephony/telephony.dart';

class AnalyseSms {
  Future analyseSms() async {
    final Telephony telephony = Telephony.instance;
    await telephony.requestPhoneAndSmsPermissions;
    final box = Hive.box("box");
    String d = box.get("lastRun", defaultValue: "");
    // Get the list of SMS messages
    List<SmsMessage> messages = await telephony.getInboxSms(
      filter: SmsFilter.where(SmsColumn.DATE).greaterThanOrEqualTo(d == ""
          ? DateTime.now()
              .subtract(const Duration(days: 93))
              .millisecondsSinceEpoch
              .toString()
          : d),
    );

    box.put("lastRun", DateTime.now().millisecondsSinceEpoch.toString());
    List<Trans.Transaction> financeMessages = [];

    // Filter messages and get financial transactions
    for (var el in messages) {
      String body = el.body!.replaceAll(",", "");
      if (body.toLowerCase().contains("debited") && !body.contains("UPDATE")) {
        final amountRegex = RegExp(r'(Rs|INR|\$)(\s|\.){1,2}?(\d+.\d{0,2})');
        final amount = amountRegex.firstMatch(body)?.groupNames;

        final upiRegex = RegExp(r'[a-zA-z0-9]{1,}@[a-zA-z0-9]{1,}');
        final upi = upiRegex.firstMatch(body)?.group(0);

        if (amount != null) {
          final onlyAmount = amountRegex.firstMatch(body)?.group(3);
          final financeMessage = Trans.Transaction(
            amount: double.parse(onlyAmount!),
            type: "debit",
            category: getCategory(body),
            upi: upi ?? "",
            smsContent: body,
            date: DateTime.fromMillisecondsSinceEpoch(el.date!),
            account: "",
          );
          FinanceDB.instance.database.then((value) {
            value.insert(Trans.Transaction.tableName, financeMessage.toJson());
          });
          financeMessages.add(financeMessage);
        }
      }
    }

    return 1;
  }

  Future<double> getCurrentMonth() async {
    Database fdb = await FinanceDB.instance.database;
    List<Map<String, Object?>> value = await fdb.rawQuery(
        "SELECT SUM(amount) as amount FROM transactions WHERE date > date('now', 'start of month')");

    return double.tryParse(value[0]['amount'].toString()) ?? 00.00;
  }

  Future<List<Map<String, Object?>>> groupedDataByCategory(
      {DateTime? dt}) async {
    dt ??= DateTime.now();
    // if (dt == null) {
    //   dt = DateTime.now();
    // }
    int lastday = DateTime(dt.year, dt.month + 1, 0).day;
    Database fdb = await FinanceDB.instance.database;
    print(DateFormat("y-MM-dd").format(dt));
    fdb
        .rawQuery(
            "select amount,date from transactions where date > date('2022-03-10') AND date < date('2022-03-18','+1 day')")
        .then((value) {
      print(value);
    });

    // fdb.update(Trans.Transaction.tableName, {"date": "2022-03-10T13:00:07.588"},
    //     where: "id=1");

    // fdb.query(Trans.Transaction.tableName,
    //     groupBy: "category",
    //     where: "date > date('" + DateFormat('y-MM-dd').format(dt) + "')",
    //     columns: [
    //       'category',
    //       'COUNT(*) as count',
    //       'SUM(amount) as total'
    //     ]).then((value) {
    //   print(value);
    // });

    return await fdb.query(Trans.Transaction.tableName,
        groupBy: "category",
        where: "date > date('" +
            DateFormat('y-MM-01').format(dt) +
            "') AND date < date('" +
            DateFormat('y-MM-' + lastday.toString()).format(dt) +
            "','+1 day')",
        columns: ['category', 'COUNT(*) as count', 'SUM(amount) as total']);
  }

  Future<List<Map<String, Object?>>> groupedDataByDate({DateTime? dt}) async {
    dt ??= DateTime.now();
    // if (dt == null) {
    //   dt = DateTime.now();
    // }
    int lastday = DateTime(dt.year, dt.month + 1, 0).day;
    Database fdb = await FinanceDB.instance.database;
    print(DateFormat("y-MM-dd").format(dt));
    fdb
        .rawQuery(
            "select amount,date from transactions where date > date('2022-03-10') AND date < date('2022-03-18','+1 day')")
        .then((value) {
      print(value);
    });

    // fdb.update(Trans.Transaction.tableName, {"date": "2022-03-10T13:00:07.588"},
    //     where: "id=1");

    // fdb.query(Trans.Transaction.tableName,
    //     groupBy: "category",
    //     where: "date > date('" + DateFormat('y-MM-dd').format(dt) + "')",
    //     columns: [
    //       'category',
    //       'COUNT(*) as count',
    //       'SUM(amount) as total'
    //     ]).then((value) {
    //   print(value);
    // });

    return await fdb.query(Trans.Transaction.tableName,
        groupBy: "date(date)",
        where: "date > date('" +
            DateFormat('y-MM-01').format(dt) +
            "') AND date < date('" +
            DateFormat('y-MM-' + lastday.toString()).format(dt) +
            "','+1 day')",
        columns: [
          'category',
          'COUNT(*) as count',
          'SUM(amount) as total',
          'date'
        ]);
  }

  String getCategory(String body) {
    if (body.contains("zomato")) {
      return "food";
    }
    if (body.contains("swiggy")) {
      return "food";
    }

    if (body.contains("irctc")) {
      return "travel";
    }

    if (body.contains("pay@") || body.contains("mobile@")) {
      return "bills";
    }

    return "general";
  }
}

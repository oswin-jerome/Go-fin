import 'package:get/get.dart';
import 'package:go_fins/db/finance-db.dart';
import 'package:go_fins/models/transaction.dart' as t;
import 'package:go_fins/services/analyse_sms.dart';
import 'package:sqflite/sqlite_api.dart';

class DashController extends GetxController {
  RxDouble totalMonthlyExpense = 0.0.obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, Object?>> groupedCategory = <Map<String, Object?>>[].obs;
  RxList<Map<String, Object?>> groupedDate = <Map<String, Object?>>[].obs;
  RxList<Map<String, Object?>> transactions = <Map<String, Object?>>[].obs;
  @override
  void onInit() {
    super.onInit();
    // totalMonthlyExpense.bindStream(AnalyseSms().getCurrentMonth());
    initalAnalyse();
    getMonthlyTotal();
  }

  getMonthlyTotal() async {
    double d = await AnalyseSms().getCurrentMonth();
    totalMonthlyExpense.value = d;
  }

  initalAnalyse() async {
    isLoading.value = true;
    // await Future.delayed(const Duration(seconds: 2));

    await AnalyseSms().analyseSms();
    isLoading.value = false;
    getMonthlyTotal();
  }

  getGroupedCategory() async {
    groupedCategory.value = await AnalyseSms().groupedDataByCategory();
  }

  getGroupedDate() async {
    groupedDate.value = await AnalyseSms().groupedDataByDate();
  }

  getTransactions({String? category}) async {
    Database fdb = await FinanceDB.instance.database;
    transactions.value = await fdb.query(
      t.Transaction.tableName,
      where: category != null
          ? "category = ? AND date>date('now','start of month')"
          : null,
      whereArgs: category != null ? [category] : null,
      orderBy: "date DESC",
    );
  }
}

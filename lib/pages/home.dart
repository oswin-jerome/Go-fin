import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_fins/controllers/dashcontroller.dart';
import 'package:go_fins/db/finance-db.dart';
import 'package:go_fins/models/transaction.dart';
import 'package:go_fins/pages/fragments/month_dash.dart';
import 'package:go_fins/pages/summary_page.dart';
import 'package:go_fins/services/analyse_sms.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final box = Hive.box("box");
  final DateTime dt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GetX<DashController>(
        init: DashController(),
        builder: (ctrl) {
          return Scaffold(
            bottomSheet: BottomSheet(
                enableDrag: false,
                onClosing: () {},
                builder: (c) {
                  return !ctrl.isLoading.value == true
                      ? Container(
                          height: 0,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.20,
                          decoration: BoxDecoration(
                            color: const Color(0xff2E313E),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text("Analyzing your expenses... "),
                            ],
                          ),
                        );
                }),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Hi,',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      box.get("name", defaultValue: ""),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              FinanceDB.instance.database.then((value) {
                                value
                                    .query(Transaction.tableName)
                                    .then((value) {
                                  print(value);
                                });
                              });
                            },
                            child: const Text("This Month")),
                        TextButton(
                          onPressed: () {
                            print("object");
                            AnalyseSms().groupedDataByCategory();
                          },
                          child: const Text(
                            "Today",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      DateFormat("MMMM").format(dt) + ' Spending',
                      style: TextStyle(),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: "main_amount",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              "Rs. ${ctrl.totalMonthlyExpense.value.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text("Add Spending"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 0,
                            sectionsSpace: 0,
                            sections: [
                              PieChartSectionData(
                                color: Colors.blue,
                                value: 25900,
                                radius: 100,
                              ),
                              PieChartSectionData(
                                radius: 100,
                                color: Colors.grey,
                                value: 2500,
                                title: "ABC",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => SummaryPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff2E313E),
                          padding: EdgeInsets.all(20)),
                      child: Text(
                        "Show Summary 🔥",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

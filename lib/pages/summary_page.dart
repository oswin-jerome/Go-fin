import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_fins/controllers/dashcontroller.dart';
import 'package:go_fins/pages/fragments/summary_category.dart';
import 'package:go_fins/pages/fragments/summary_trend.dart';
import 'package:intl/intl.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (bc, i) {
              return [
                SliverAppBar(
                  backgroundColor: Color(0xff2E313E),
                  elevation: 10,
                  pinned: true,
                  collapsedHeight: 150,
                  expandedHeight: 200,
                  // leading: Text(""),
                  flexibleSpace: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 32),
                          Text(
                            DateFormat("MMMM").format(DateTime.now()) +
                                ' Spending',
                            style: TextStyle(),
                          ),
                          SizedBox(height: 5),
                          GetX<DashController>(
                              init: DashController(),
                              builder: (ctrl) {
                                return Hero(
                                  tag: "main_amount",
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      "Rs. ${ctrl.totalMonthlyExpense.value.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(height: 42),
                        ],
                      ),
                    ),
                  ),
                  bottom: const TabBar(tabs: [
                    Tab(
                      child: Text(
                        "Categories",
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Trends",
                      ),
                    ),
                  ]),
                ),
              ];
            },
            body: TabBarView(children: [
              SummaryCategory(),
              SummaryTrend(),
            ])),
      ),
    );
  }
}

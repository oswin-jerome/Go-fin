import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_fins/controllers/dashcontroller.dart';
import 'package:go_fins/pages/transaction_list.dart';
import 'package:go_fins/utils/helper.dart';
import 'package:intl/intl.dart';

class SummaryTrend extends StatelessWidget {
  const SummaryTrend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: GetX<DashController>(
                  init: DashController(),
                  builder: (ctrl) {
                    int i = 0;
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2))),
                          gridData: FlGridData(show: false),
                          barGroups: ctrl.groupedDate.map((element) {
                            i++;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY:
                                      double.parse(element['total'].toString()),
                                  colors: [Colors.blue, Colors.blueGrey],
                                  width: 20,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ],
                            );
                          }).toList(),
                          groupsSpace: 10,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: SideTitles(showTitles: false),
                            topTitles: SideTitles(showTitles: false),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              rotateAngle: -45,
                              getTextStyles: (nc, i) {
                                return const TextStyle(
                                    color: Colors.white, fontSize: 10);
                              },
                              getTitles: (value) {
                                // return value.toString() + "s";
                                return DateFormat("MMM dd").format(
                                    DateTime.parse(ctrl
                                        .groupedDate[value.toInt() - 1]['date']
                                        .toString()));
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Breakdown",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          GetX<DashController>(
              init: DashController(),
              initState: (d) {
                d.controller?.getGroupedDate();
              },
              builder: (ctrl) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: ctrl.groupedDate.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (bc, i) {
                    return Card(
                      color: const Color(0xff2E313E),
                      child: ListTile(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (bc) => TransactionList(
                                  category: ctrl.groupedCategory[i]['category']
                                      .toString()),
                            ),
                          );
                        }),
                        // leading: Text(
                        //     Helper.getCategoryEmojie(
                        //         ctrl.groupedDate[i]['category'].toString()),
                        //     style: const TextStyle(fontSize: 28)),
                        title: Text("${ctrl.groupedDate[i]['count']} Expenses",
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          "On ${DateFormat("MMM dd y").format(DateTime.parse(ctrl.groupedDate[i]['date'].toString()))}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        trailing: Text(
                          "Rs. ${double.parse(ctrl.groupedDate[i]['total'].toString()).toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              }),
        ]),
      ),
    );
  }
}

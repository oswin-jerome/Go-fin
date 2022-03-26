import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_fins/controllers/dashcontroller.dart';
import 'package:go_fins/pages/transaction_list.dart';
import 'package:go_fins/utils/helper.dart';

class SummaryCategory extends StatelessWidget {
  const SummaryCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 32),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.20),
            child: AspectRatio(
              aspectRatio: 1,
              child: GetX<DashController>(
                  init: DashController(),
                  builder: (ctrl) {
                    return PieChart(
                      PieChartData(
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                        sections: ctrl.groupedCategory.map((element) {
                          return PieChartSectionData(
                            // color: Colors.blue,
                            color: Helper.getCategoryColor(
                                element['category'].toString()),
                            value: double.parse(element['total'].toString()),
                            title: element['category'].toString(),

                            radius: 100,
                          );
                        }).toList(),
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
                print("+++++++++++++++");
                d.controller?.getGroupedCategory();
              },
              builder: (ctrl) {
                print(ctrl.groupedCategory.length);

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: ctrl.groupedCategory.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (bc, i) {
                    return Card(
                      color: Color(0xff2E313E),
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
                        leading: Text(
                            Helper.getCategoryEmojie(
                                ctrl.groupedCategory[i]['category'].toString()),
                            style: const TextStyle(fontSize: 28)),
                        title: Text(
                            "${ctrl.groupedCategory[i]['count']} Expenses",
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                          "On ${ctrl.groupedCategory[i]['category']}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        trailing: Text(
                            "Rs. ${double.parse(ctrl.groupedCategory[i]['total'].toString()).toStringAsFixed(2)}",
                            style: TextStyle(color: Colors.white)),
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

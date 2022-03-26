import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_fins/controllers/dashcontroller.dart';
import 'package:go_fins/pages/transaction_details.dart';
import 'package:go_fins/utils/helper.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  String? category;
  TransactionList({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: GetX<DashController>(
            init: DashController(),
            initState: (d) {
              d.controller?.getTransactions(category: category);
            },
            builder: (ctrl) {
              return ListView.builder(
                itemCount: ctrl.transactions.length,
                itemBuilder: (context, i) {
                  return Card(
                    color: const Color(0xff2E313E),
                    child: ListTile(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (bc) => TransactionDetails(
                                transaction: ctrl.transactions[i]),
                          ),
                        );
                      }),
                      leading: Text(
                          Helper.getCategoryEmojie(
                              ctrl.transactions[i]['category'].toString()),
                          style: const TextStyle(fontSize: 28)),
                      title: Text("Rs. ${ctrl.transactions[i]['amount']}",
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        "${ctrl.transactions[i]['upi']}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      trailing: Text(
                          "📆 ${DateFormat('MMM d yyy').format(DateTime.parse(ctrl.transactions[i]['date'].toString()))}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

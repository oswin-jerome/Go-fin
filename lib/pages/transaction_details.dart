import 'package:flutter/material.dart';
import 'package:go_fins/utils/helper.dart';

class TransactionDetails extends StatelessWidget {
  Map<String, Object?> transaction;
  TransactionDetails({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 32,
          ),
          Center(
            child: Text(
              "Rs. ${double.parse(transaction['amount'].toString()).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              transaction['upi'].toString(),
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.white.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category"),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    Helper.getCategoryEmojie(
                      transaction['category'].toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(0.2),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("Sms Content"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              transaction['sms_content'].toString(),
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  static const tableName = 'transactions';

  Transaction(
      {this.id,
      this.amount,
      this.upi,
      this.type,
      this.smsContent,
      this.account,
      this.category,
      this.date});

  int? id;
  double? amount;
  String? upi;
  String? type;
  String? smsContent;
  String? account;
  String? category;
  DateTime? date;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        amount: json["amount"],
        upi: json["upi"],
        type: json["type"],
        smsContent: json["sms_content"],
        category: json["category"],
        date: DateTime.parse(json["date"]),
        account: json["account"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "upi": upi,
        "type": type,
        "sms_content": smsContent,
        "category": category,
        "date": date?.toIso8601String(),
        "account": account,
      };
}

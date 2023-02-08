import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AmountPrintModel {
  final int amount;
  AmountPrintModel({
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
    };
  }

  factory AmountPrintModel.fromMap(Map<String, dynamic> map) {
    return AmountPrintModel(
      amount: (map['amount'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AmountPrintModel.fromJson(String source) => AmountPrintModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

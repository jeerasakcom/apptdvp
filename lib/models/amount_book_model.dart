import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AmountBookModel {
  final int amount;
  AmountBookModel({
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
    };
  }

  factory AmountBookModel.fromMap(Map<String, dynamic> map) {
    return AmountBookModel(
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AmountBookModel.fromJson(String source) =>
      AmountBookModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

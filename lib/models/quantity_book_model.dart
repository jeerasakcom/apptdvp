import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class QuantityBookModel {
  final int quantity;
  QuantityBookModel({
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
    };
  }

  factory QuantityBookModel.fromMap(Map<String, dynamic> map) {
    return QuantityBookModel(
      quantity: (map['quantity'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuantityBookModel.fromJson(String source) =>
      QuantityBookModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

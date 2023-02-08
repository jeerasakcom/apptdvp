import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class QuantityPageModel {
  final int quantity;
  QuantityPageModel({
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
    };
  }

  factory QuantityPageModel.fromMap(Map<String, dynamic> map) {
    return QuantityPageModel(
      quantity: (map['quantity'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuantityPageModel.fromJson(String source) =>
      QuantityPageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

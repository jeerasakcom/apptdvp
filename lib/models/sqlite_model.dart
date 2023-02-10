import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String productname;
  final String price;
  final String quantity;
  final String sum;
  final String docProduct;
  final String docStock;
  SQLiteModel({
    this.id,
    required this.productname,
    required this.price,
    required this.quantity,
    required this.sum,
    required this.docProduct,
    required this.docStock,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productname': productname,
      'price': price,
      'quantity': quantity,
      'sum': sum,
      'docProduct': docProduct,
      'docStock': docStock,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: (map['id'] ?? 0) as int,
      productname: (map['productname'] ?? '') as String,
      price: (map['price'] ?? '') as String,
      quantity: (map['quantity'] ?? '') as String,
      sum: (map['sum'] ?? '') as String,
      docProduct: (map['docProduct'] ?? '') as String,
      docStock: (map['docStock'] ?? '') as String,
    );
  }

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

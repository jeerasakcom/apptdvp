import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final Timestamp ordertimes;
  final String ordernumber;
  final String customerfname;
  final String customerlname;
  final String customeraddress;
  final String customersubdistrict;
  final String customerdistrict;
  final String customerprovince;
  final String customerzipcode;
  final String customerphone;
  final List<Map<String, dynamic>> productslists;
  final String status;
  final String ordertotal;
  final String payments;
  final String logistics;
  final String uidcustomer;
  final String bankstatement;
  OrderModel({
    required this.ordertimes,
    required this.ordernumber,
    required this.customerfname,
    required this.customerlname,
    required this.customeraddress,
    required this.customersubdistrict,
    required this.customerdistrict,
    required this.customerprovince,
    required this.customerzipcode,
    required this.customerphone,
    required this.productslists,
    required this.status,
    required this.ordertotal,
    required this.payments,
    required this.logistics,
    required this.uidcustomer,
    required this.bankstatement,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ordertimes': ordertimes,
      'ordernumber': ordernumber,
      'customerfname': customerfname,
      'customerlname': customerlname,
      'customeraddress': customeraddress,
      'customersubdistrict': customersubdistrict,
      'customerdistrict': customerdistrict,
      'customerprovince': customerprovince,
      'customerzipcode': customerzipcode,
      'customerphone': customerphone,
      'productslists': productslists,
      'status': status,
      'ordertotal': ordertotal,
      'payments': payments,
      'logistics': logistics,
      'uidcustomer': uidcustomer,
      'bankstatement': bankstatement,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      ordertimes: (map['ordertimes']),
      ordernumber: (map['ordernumber'] ?? '') as String,
      customerfname: (map['customerfname'] ?? '') as String,
      customerlname: (map['customerlname'] ?? '') as String,
      customeraddress: (map['customeraddress'] ?? '') as String,
      customersubdistrict: (map['customersubdistrict'] ?? '') as String,
      customerdistrict: (map['customerdistrict'] ?? '') as String,
      customerprovince: (map['customerprovince'] ?? '') as String,
      customerzipcode: (map['customerzipcode'] ?? '') as String,
      customerphone: (map['customerphone'] ?? '') as String,
      productslists: List<Map<String, dynamic>>.from(map['productslists']),
      status: (map['status'] ?? '') as String,
      ordertotal: (map['ordertotal'] ?? '') as String,
      payments: (map['payments'] ?? '') as String,
      logistics: (map['logistics'] ?? '') as String,
      uidcustomer: (map['uidcustomer'] ?? '') as String,
      bankstatement: (map['bankstatement'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

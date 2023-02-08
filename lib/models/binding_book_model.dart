import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BindingBookModel {
  final String bindingbook;
  final String factor;
  BindingBookModel({
    required this.bindingbook,
    required this.factor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bindingbook': bindingbook,
      'factor': factor,
    };
  }

  factory BindingBookModel.fromMap(Map<String, dynamic> map) {
    return BindingBookModel(
      bindingbook: map['bindingbook'] as String,
      factor: map['factor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BindingBookModel.fromJson(String source) =>
      BindingBookModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

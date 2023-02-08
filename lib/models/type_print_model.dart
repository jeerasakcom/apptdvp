import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TypePrintModel {
  final String typeprint;
  final String factor;
  TypePrintModel({
    required this.typeprint,
    required this.factor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'typeprint': typeprint,
      'factor': factor,
    };
  }

  factory TypePrintModel.fromMap(Map<String, dynamic> map) {
    return TypePrintModel(
      typeprint: map['typeprint'] as String,
      factor: map['factor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TypePrintModel.fromJson(String source) =>
      TypePrintModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

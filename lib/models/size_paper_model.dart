import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SizePaperModel {
  final String size;
  final String factor;
  SizePaperModel({
    required this.size,
    required this.factor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'factor': factor,
    };
  }

  factory SizePaperModel.fromMap(Map<String, dynamic> map) {
    return SizePaperModel(
      size: (map['size'] ?? '') as String,
      factor: (map['factor'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SizePaperModel.fromJson(String source) => SizePaperModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FormatPaperModel {
  final String paper;
  FormatPaperModel({
    required this.paper,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paper': paper,
    };
  }

  factory FormatPaperModel.fromMap(Map<String, dynamic> map) {
    return FormatPaperModel(
      paper: (map['paper'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormatPaperModel.fromJson(String source) => FormatPaperModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

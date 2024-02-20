import 'package:json_annotation/json_annotation.dart';
part 'part.g.dart';

@JsonSerializable()
class Part {
  String text;
  Part({required this.text});

  @override
  String toString() {
    return 'Part{text: $text}';
  }

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);

  Map<String, dynamic> toJson() => _$PartToJson(this);
}

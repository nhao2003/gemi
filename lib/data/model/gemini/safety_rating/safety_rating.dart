import 'package:json_annotation/json_annotation.dart';

part 'safety_rating.g.dart';

@JsonSerializable()
class SafetyRating {
  String? category;
  String? probability;

  SafetyRating({this.category, this.probability});

  factory SafetyRating.fromJson(Map<String, dynamic> json) =>
      _$SafetyRatingFromJson(json);

  Map<String, dynamic> toJson() => _$SafetyRatingToJson(this);

  static List<SafetyRating> jsonToList(List list) => list
      .map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
      .toList();
}

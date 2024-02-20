import 'package:json_annotation/json_annotation.dart';

import '../content/content.dart';
import '../safety_rating/safety_rating.dart';
part 'candidate.g.dart';

@JsonSerializable()
class Candidate {
  Content? content;
  String? finishReason;
  int? index;
  List<SafetyRating>? safetyRatings;

  Candidate({this.content, this.finishReason, this.index, this.safetyRatings});

  factory Candidate.fromJson(Map<String, Object?> json) =>
      _$CandidateFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateToJson(this);

  static List<Candidate> jsonToList(List list) =>
      list.map((e) => Candidate.fromJson(e as Map<String, dynamic>)).toList();
}

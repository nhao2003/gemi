import 'package:json_annotation/json_annotation.dart';

import '../safety_rating/safety_rating.dart';

part 'prompt_feedback.g.dart';

@JsonSerializable()
class PromptFeedback {
  List<SafetyRating>? safetyRatings;

  PromptFeedback({this.safetyRatings});

  factory PromptFeedback.fromJson(Map<String, dynamic> json) =>
      _$PromptFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$PromptFeedbackToJson(this);

  @override
  String toString() {
    return 'PromptFeedback{safetyRatings: $safetyRatings}';
  }
}

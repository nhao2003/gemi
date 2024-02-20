import 'package:json_annotation/json_annotation.dart';

import '../candidate/candidate.dart';
import '../prompt_feedback/prompt_feedback.dart';
part 'gemini_response.g.dart';

@JsonSerializable()
class GeminiResponse {
  List<Candidate>? candidates;
  PromptFeedback? promptFeedback;

  GeminiResponse({this.candidates, this.promptFeedback});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) =>
      _$GeminiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiResponseToJson(this);

  @override
  String toString() {
    return 'GeminiResponse{candidates: $candidates, promptFeedback: $promptFeedback}';
  }
}

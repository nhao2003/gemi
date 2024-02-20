import 'package:json_annotation/json_annotation.dart';
part 'gemini_model.g.dart';

@JsonSerializable()
class GeminiModel {
  String? name;
  String? version;
  String? displayName;
  String? description;
  int? inputTokenLimit;
  int? outputTokenLimit;
  List<String>? supportedGenerationMethods;
  double? temperature;
  double? topP;
  int? topK;

  GeminiModel({
    this.name,
    this.version,
    this.displayName,
    this.description,
    this.inputTokenLimit,
    this.outputTokenLimit,
    this.supportedGenerationMethods,
    this.temperature,
    this.topP,
    this.topK,
  });

  factory GeminiModel.fromJson(Map<String, dynamic> json) =>
      _$GeminiModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiModelToJson(this);

  static List<GeminiModel> jsonToList(List list) =>
      list.map((e) => GeminiModel.fromJson(e as Map<String, dynamic>)).toList();
}

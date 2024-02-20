import 'package:json_annotation/json_annotation.dart';
part 'generation_config.g.dart';

@JsonSerializable()
class GenerationConfig {
  List<String>? stopSequences;
  double? temperature;
  int? maxOutputTokens;
  double? topP;
  int? topK;

  GenerationConfig({
    this.stopSequences,
    this.temperature,
    this.maxOutputTokens,
    this.topP,
    this.topK,
  });

  factory GenerationConfig.fromJson(Map<String, dynamic> json) =>
      _$GenerationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GenerationConfigToJson(this);
}

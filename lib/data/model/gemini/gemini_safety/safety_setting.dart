import 'package:json_annotation/json_annotation.dart';

import 'safety_category.dart';
import 'safety_threshold.dart';
part 'safety_setting.g.dart';

@JsonSerializable()
class SafetySetting {
  final SafetyCategory category;
  final SafetyThreshold threshold;

  SafetySetting({
    required this.category,
    required this.threshold,
  });

  factory SafetySetting.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingFromJson(json);

  Map<String, dynamic> toJson() => _$SafetySettingToJson(this);
}

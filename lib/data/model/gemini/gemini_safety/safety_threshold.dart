import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum SafetyThreshold {
  ///	Always show regardless of probability of unsafe content
  @JsonValue('BLOCK_NONE')
  blockNone,

  /// Block when high probability of unsafe content
  @JsonValue('BLOCK_ONLY_HIGH')
  blockOnlyHigh,

  /// Block when medium or high probability of unsafe content
  @JsonValue('BLOCK_MEDIUM_AND_ABOVE')
  blockMediumAndAbove,

  /// Block when low, medium or high probability of unsafe content
  @JsonValue('BLOCK_LOW_AND_ABOVE')
  blockLowAndAbove,

  /// Threshold is unspecified, block using default threshold
  @JsonValue('HARM_BLOCK_THRESHOLD_UNSPECIFIED')
  harmBlockThresholdUnspecified;

  String get displayName {
    switch (this) {
      case SafetyThreshold.blockNone:
        return 'Block None';
      case SafetyThreshold.blockOnlyHigh:
        return 'Block few';
      case SafetyThreshold.blockMediumAndAbove:
        return 'Block some';
      case SafetyThreshold.blockLowAndAbove:
        return 'Block most';
      case SafetyThreshold.harmBlockThresholdUnspecified:
        return 'Harm Block Threshold Unspecified';
    }
  }
}

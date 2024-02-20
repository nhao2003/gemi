import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum SafetyCategory {
  /// Negative or harmful comments targeting identity and/or protected attributes.
  @JsonValue('HARM_CATEGORY_HARASSMENT')
  harassment,

  /// Content that is rude, disrespectful, or profane.
  @JsonValue('HARM_CATEGORY_HATE_SPEECH')
  hateSpeech,

  /// Contains references to sexual acts or other lewd content.
  @JsonValue('HARM_CATEGORY_SEXUALLY_EXPLICIT')
  sexuallyExplicit,

  /// Promotes, facilitates, or encourages harmful acts.
  @JsonValue('HARM_CATEGORY_DANGEROUS_CONTENT')
  dangerous;

  String get displayName {
    switch (this) {
      case SafetyCategory.harassment:
        return 'Harassment';
      case SafetyCategory.hateSpeech:
        return 'Hate Speech';
      case SafetyCategory.sexuallyExplicit:
        return 'Sexually Explicit';
      case SafetyCategory.dangerous:
        return 'Dangerous Content';
    }
  }
}

import 'package:json_annotation/json_annotation.dart';
import '../part/part.dart';
part 'content.g.dart';

@JsonEnum()
enum Role {
  @JsonValue('user')
  user,
  @JsonValue('model')
  model;
}

@JsonSerializable()
class Content {
  List<Part>? parts;
  Role? role;

  Content({required this.parts, required this.role});

  @override
  String toString() {
    return 'Content{parts: $parts, role: $role}';
  }

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

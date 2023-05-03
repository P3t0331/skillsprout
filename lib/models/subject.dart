import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart';

@JsonSerializable()
class Subject {
  final String id;
  final String authorId;
  final String code;
  final String name;
  final List<String> deadlineIds;
  final int requiredVotes;
  final int memberCount;

  Subject(
      {this.id = "",
      required this.code,
      required this.name,
      required this.authorId,
      this.deadlineIds = const [],
      this.requiredVotes = 3,
      this.memberCount = 0});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

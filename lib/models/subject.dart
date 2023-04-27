import 'package:json_annotation/json_annotation.dart';

import 'deadline.dart';

part 'subject.g.dart';

@JsonSerializable()
class Subject {
  final String code;
  final String name;
  final List<String> deadlineIds;
  final int requiredVotes;

  Subject(
      {required this.code,
      required this.name,
      this.deadlineIds = const [],
      this.requiredVotes = 3});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

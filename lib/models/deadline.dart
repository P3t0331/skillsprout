import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deadline.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class Deadline {
  final String title;
  @TimestampConverter()
  final DateTime date;
  final String description;
  final List<String> upvoteIds;
  final List<String> downvoteIds;
  final String subjectRef;

  Deadline(
      {required this.title,
      required this.date,
      required this.subjectRef,
      this.description = "",
      this.upvoteIds = const [],
      this.downvoteIds = const []});

  factory Deadline.fromJson(Map<String, dynamic> json) =>
      _$DeadlineFromJson(json);

  Map<String, dynamic> toJson() => _$DeadlineToJson(this);
}

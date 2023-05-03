// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deadline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deadline _$DeadlineFromJson(Map<String, dynamic> json) => Deadline(
      id: json['id'] as String? ?? "",
      title: json['title'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      subjectRef: json['subjectRef'] as String,
      authorId: json['authorId'] as String,
      description: json['description'] as String? ?? "",
      upvoteIds: (json['upvoteIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      downvoteIds: (json['downvoteIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DeadlineToJson(Deadline instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': const TimestampConverter().toJson(instance.date),
      'description': instance.description,
      'upvoteIds': instance.upvoteIds,
      'downvoteIds': instance.downvoteIds,
      'subjectRef': instance.subjectRef,
      'authorId': instance.authorId,
    };

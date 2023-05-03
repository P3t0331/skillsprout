// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      id: json['id'] as String? ?? "",
      code: json['code'] as String,
      name: json['name'] as String,
      authorId: json['authorId'] as String,
      deadlineIds: (json['deadlineIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requiredVotes: json['requiredVotes'] as int? ?? 3,
      memberCount: json['memberCount'] as int? ?? 0,
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'code': instance.code,
      'name': instance.name,
      'deadlineIds': instance.deadlineIds,
      'requiredVotes': instance.requiredVotes,
      'memberCount': instance.memberCount,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      code: json['code'] as String,
      name: json['name'] as String,
      deadlineIds: (json['deadlineIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requiredVotes: json['requiredVotes'] as int? ?? 3,
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'deadlineIds': instance.deadlineIds,
      'requiredVotes': instance.requiredVotes,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      email: json['email'] as String,
      name: json['name'] as String,
      subjectIds: (json['subjectIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'subjectIds': instance.subjectIds,
    };

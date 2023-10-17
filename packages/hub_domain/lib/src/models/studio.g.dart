// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Studio _$StudioFromJson(Map<String, dynamic> json) => Studio(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$StudioToJson(Studio instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'userId': instance.userId,
      'website': instance.website,
    };

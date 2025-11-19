// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  author: json['brand'] as String? ?? '',
  description: json['description'] as String,
  image: json['thumbnail'] as String,
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'brand': instance.author,
  'description': instance.description,
  'thumbnail': instance.image,
};

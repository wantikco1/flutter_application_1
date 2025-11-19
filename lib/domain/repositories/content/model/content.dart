// lib/domain/repositories/content/model/content.dart
import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart'; // ОН ИЩЕТ ЭТОТ ФАЙЛ, А НЕ ЭКРАН

@JsonSerializable()
class Content {
  final int id;
  final String title;

  @JsonKey(name: 'brand', defaultValue: '')
  final String author;

  final String description;

  @JsonKey(name: 'thumbnail') 
  final String image;

  Content({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.image,
  });

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
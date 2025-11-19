// lib/domain/repositories/content/content_repository_interface.dart
import 'model/content.dart';

abstract interface class ContentRepositoryInterface {
  /// Список контента для первого экрана
  Future<List<Content>> getContent();

  /// Один элемент по id для второго экрана
  Future<Content> getContentById(int id);
}
// lib/data/dio/endpoints.dart
class Endpoints {
  Endpoints._();

  /// Список товаров
  static const String content = '/products';

  /// Детали товара по id
  static String contentById(int id) => '/products/$id';
}
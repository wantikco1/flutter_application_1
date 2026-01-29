// lib/domain/repositories/favorite/favorite_repository_interface.dart
import '../content/model/content.dart';

abstract interface class FavoriteRepositoryInterface {
  Future<void> addFavorite({
    required String userId,
    required Content content,
  });

  Future<void> removeFavorite({
    required String userId,
    required int contentId,
  });

  Future<List<Content>> getFavorites({
    required String userId,
  });
}



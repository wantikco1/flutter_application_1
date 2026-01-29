// lib/domain/repositories/favorite/favorite_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../content/model/content.dart';
import 'favorite_repository_interface.dart';

class FavoriteRepository implements FavoriteRepositoryInterface {
  FavoriteRepository({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('favorites');

  String _docId(String userId, int contentId) => '${userId}_$contentId';

  @override
  Future<void> addFavorite({
    required String userId,
    required Content content,
  }) async {
    final data = content.toJson()
      ..addAll({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

    await _collection.doc(_docId(userId, content.id)).set(data);
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required int contentId,
  }) async {
    await _collection.doc(_docId(userId, contentId)).delete();
  }

  @override
  Future<List<Content>> getFavorites({required String userId}) async {
    final querySnapshot =
        await _collection.where('userId', isEqualTo: userId).get();

    return querySnapshot.docs
        .map(
          (doc) => Content.fromJson(doc.data()),
        )
        .toList();
  }
}



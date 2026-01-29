// lib/app/widgets/content_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/content/model/content.dart'; // <-- ИМПОРТ

class ContentCard extends StatelessWidget {
  // Принимаем 'content'
  const ContentCard({
    super.key,
    required this.content,
    this.isFavorite = false,
    this.showFavorite = false,
    this.onFavoritePressed,
  });

  final Content content;
  final bool isFavorite;
  final bool showFavorite;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final imageSize = 100.0;
    return InkWell(
      // Используем 'content.id'
      onTap: () => context.push('/content/${content.id}'),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              // Используем Image.network для 'content.image'
              child: Image.network(
                content.image, // <-- ИЗМЕНЕНО
                height: imageSize,
                width: imageSize,
                fit: BoxFit.cover,
                // Добавим обработку ошибок для URL
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          content.title, // <-- ИЗМЕНЕНО
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (showFavorite)
                        IconButton(
                          onPressed: onFavoritePressed,
                          icon: Icon(
                            Icons.star,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      content.description, // <-- ИЗМЕНЕНО
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
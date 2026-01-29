// lib/app/features/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../widgets/widgets.dart';
import 'bloc/favorites_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<FavoritesBloc>()..add(const FavoritesLoad());

    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesInitial || state is FavoritesLoadInProgress) {
            return Scaffold(
              appBar: AppBar(title: const Text('Избранное')),
              body: const Center(child: AppProgressIndicator()),
            );
          } else if (state is FavoritesLoadFailure) {
            return Scaffold(
              appBar: AppBar(title: const Text('Избранное')),
              body: Center(
                child: AppError(
                  description: state.exception.toString(),
                  onTap: () => context
                      .read<FavoritesBloc>()
                      .add(const FavoritesLoad()),
                ),
              ),
            );
          } else if (state is FavoritesLoadSuccess) {
            final favorites = state.favorites;

            return Scaffold(
              appBar: AppBar(title: const Text('Избранное')),
              body: favorites.isEmpty
                  ? const Center(
                      child: Text('У вас пока нет избранных товаров'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: favorites.length,
                      itemBuilder: (_, index) => ContentCard(
                        content: favorites[index],
                        isFavorite: true,
                        onFavoritePressed: () {
                          context.read<FavoritesBloc>().add(
                                FavoriteToggled(
                                  content: favorites[index],
                                ),
                              );
                        },
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                    ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Избранное')),
              body: const Center(child: AppProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}



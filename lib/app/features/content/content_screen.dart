// lib/app/features/content/content_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import '../favorites/bloc/favorites_bloc.dart';
import 'bloc/content_bloc.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key, required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(contentId);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ContentBloc>()..add(ContentLoad(id: id ?? 0)),
        ),
        BlocProvider(
          create: (_) => getIt<FavoritesBloc>()..add(const FavoritesLoad()),
        ),
      ],
      child: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state is ContentInitial || state is ContentLoadInProgress) {
            return const Scaffold(
              body: Center(child: AppProgressIndicator()),
            );
          } else if (state is ContentLoadFailure) {
            return Scaffold(
              body: Center(
                child: AppError(
                  description: state.exception.toString(),
                  onTap: () => context
                      .read<ContentBloc>()
                      .add(ContentLoad(id: id ?? 0)),
                ),
              ),
            );
          } else if (state is ContentLoadSuccess) {
            return _ContentView(contentState: state);
          } else {
            return const Scaffold(
              body: Center(child: AppProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({required this.contentState});

  final ContentLoadSuccess contentState;

  @override
  Widget build(BuildContext context) {
    final content = contentState.content;
    final auth = getIt<FirebaseAuth>();

    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favState) {
        final user = auth.currentUser;
        final showFavorite = user != null;

        final favoritesIds = favState is FavoritesLoadSuccess
            ? favState.favorites.map((e) => e.id).toSet()
            : <int>{};

        final isFavorite = favoritesIds.contains(content.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(content.title),
            actions: [
              if (showFavorite)
                IconButton(
                  onPressed: () {
                    context
                        .read<FavoritesBloc>()
                        .add(FavoriteToggled(content: content));
                  },
                  icon: Icon(
                    Icons.star,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    content.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                16.ph,
                Text(
                  content.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                8.ph,
                Text(
                  content.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
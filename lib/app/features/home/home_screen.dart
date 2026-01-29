// lib/app/features/home/home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../di/di.dart';
import '../../../domain/repositories/auth/auth_repository_interface.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import '../favorites/bloc/favorites_bloc.dart';

// Важно: если ты удалил event/state файлы, импортируй bloc.
// Если нет, оставь 'bloc/home_bloc.dart'
import 'bloc/home_block.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _home = getIt<HomeBloc>();
  final _favorites = getIt<FavoritesBloc>();
  final _auth = getIt<FirebaseAuth>();

  void loadHome() => _home.add(HomeLoad());

  @override
  void initState() {
    loadHome();
    _favorites.add(const FavoritesLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user == null) {
                return Row(
                  children: [
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Log in'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: const Text('Sign Up'),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    TextButton(
                      onPressed: () => context.go('/favorites'),
                      child: const Text('Избранное'),
                    ),
                    IconButton(
                      onPressed: () async {
                        await getIt<AuthRepositoryInterface>().signOut();
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _home,
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => _buildHomeInitial(),
            HomeLoadInProgress() => _buildHomeLoadInProgress(),
            HomeLoadSuccess() => _buildHomeLoadSuccess(state),
            HomeLoadFailure() => _buildHomeLoadFailure(state),
            // 'default' нужен, если event/state не в одном файле
            _ => _buildHomeInitial(),
          };
        },
      ),
    );
  }

  Widget _buildHomeInitial() => SizedBox.shrink();

  Widget _buildHomeLoadInProgress() => AppProgressIndicator();

  Widget _buildHomeLoadSuccess(HomeLoadSuccess state) {
    final content = state.content;

    return BlocBuilder<FavoritesBloc, FavoritesState>(
      bloc: _favorites,
      builder: (context, favState) {
        final user = _auth.currentUser;
        final showFavorites = user != null;

        final favoritesIds = favState is FavoritesLoadSuccess
            ? favState.favorites.map((e) => e.id).toSet()
            : <int>{};

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Header',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: content.length,
                itemBuilder: (_, index) {
                  final item = content[index];
                  final isFavorite = favoritesIds.contains(item.id);
                  return ContentCard(
                    content: item,
                    showFavorite: showFavorites,
                    isFavorite: isFavorite,
                    onFavoritePressed: () {
                      _favorites.add(FavoriteToggled(content: item));
                    },
                  );
                },
                separatorBuilder: (_, __) => 16.ph,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeLoadFailure(HomeLoadFailure state) {
    return AppError(
      description: state.exception.toString(),
      onTap: () => loadHome(),
    );
  }
}
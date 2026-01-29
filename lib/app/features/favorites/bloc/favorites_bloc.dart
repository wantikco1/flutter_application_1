// lib/app/features/favorites/bloc/favorites_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../di/di.dart';
import '../../../../domain/repositories/content/model/content.dart';
import '../../../../domain/repositories/favorite/favorite_repository_interface.dart';

// --- EVENTS ---

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesLoad extends FavoritesEvent {
  const FavoritesLoad();
}

class FavoriteToggled extends FavoritesEvent {
  const FavoriteToggled({required this.content});

  final Content content;

  @override
  List<Object?> get props => [content];
}

// --- STATES ---

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoadInProgress extends FavoritesState {}

final class FavoritesLoadSuccess extends FavoritesState {
  const FavoritesLoadSuccess({required this.favorites});

  final List<Content> favorites;

  @override
  List<Object?> get props => [favorites];
}

final class FavoritesLoadFailure extends FavoritesState {
  const FavoritesLoadFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}

// --- BLOC ---

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._repository, this._firebaseAuth)
      : super(FavoritesInitial()) {
    on<FavoritesLoad>(_onLoad);
    on<FavoriteToggled>(_onToggled);
  }

  final FavoriteRepositoryInterface _repository;
  final FirebaseAuth _firebaseAuth;

  Future<void> _onLoad(
    FavoritesLoad event,
    Emitter<FavoritesState> emit,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      emit(const FavoritesLoadSuccess(favorites: []));
      return;
    }

    try {
      emit(FavoritesLoadInProgress());
      final favorites = await _repository.getFavorites(userId: user.uid);
      emit(FavoritesLoadSuccess(favorites: favorites));
    } catch (exception, stackTrace) {
      emit(FavoritesLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }

    final currentState = state;
    List<Content> currentFavorites = [];
    if (currentState is FavoritesLoadSuccess) {
      currentFavorites = List<Content>.from(currentState.favorites);
    }

    final exists =
        currentFavorites.any((item) => item.id == event.content.id);

    try {
      if (exists) {
        await _repository.removeFavorite(
          userId: user.uid,
          contentId: event.content.id,
        );
        currentFavorites.removeWhere((item) => item.id == event.content.id);
      } else {
        await _repository.addFavorite(
          userId: user.uid,
          content: event.content,
        );
        currentFavorites.insert(0, event.content);
      }
      emit(FavoritesLoadSuccess(favorites: currentFavorites));
    } catch (exception, stackTrace) {
      emit(FavoritesLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }
}



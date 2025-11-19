// lib/app/features/home/bloc/home_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

//
// ИСПРАВЛЕННЫЕ ОТНОСИТЕЛЬНЫЕ ИМПОРТЫ
//
import '../../../../domain/repositories/content/content_repository_interface.dart';
import '../../../../domain/repositories/content/model/content.dart';
import '../../../../di/di.dart'; // для talker


// --- ОПРЕДЕЛЕНИЕ СОБЫТИЙ (Events) ---
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoad extends HomeEvent {
  const HomeLoad({this.completer});

  final Completer? completer;

  @override
  List<Object> get props => [];
}

// --- ОПРЕДЕЛЕНИЕ СОСТОЯНИЙ (States) ---
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoadInProgress extends HomeState {}

final class HomeLoadSuccess extends HomeState {
  const HomeLoadSuccess({ required this.content});

  final List<Content> content;

  @override
  List<Object> get props => [content];
}

final class HomeLoadFailure extends HomeState {
  const HomeLoadFailure({required this.exception});

  final Object? exception;

  @override
  List<Object> get props => [];
}


// --- ОСНОВНОЙ КЛАСС BLOC ---
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContentRepositoryInterface contentRepository;

  HomeBloc(this.contentRepository) : super(HomeInitial()) {
    on<HomeLoad>(_homeLoad);
  }

  Future<void> _homeLoad(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      if (state is! HomeLoadSuccess) {
        emit(HomeLoadInProgress());
      }
      final content = await contentRepository.getContent();
      emit(HomeLoadSuccess(content: content));
    } catch (exception, stackTrace) {
      emit(HomeLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}
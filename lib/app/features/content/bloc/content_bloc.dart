// lib/app/features/content/bloc/content_bloc.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/content/content_repository_interface.dart';
import '../../../../domain/repositories/content/model/content.dart';
import '../../../../di/di.dart';

// --- EVENTS ---

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class ContentLoad extends ContentEvent {
  const ContentLoad({required this.id, this.completer});

  final int id;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [id];
}

// --- STATES ---

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoadInProgress extends ContentState {}

class ContentLoadSuccess extends ContentState {
  const ContentLoadSuccess({required this.content});

  final Content content;

  @override
  List<Object?> get props => [content];
}

class ContentLoadFailure extends ContentState {
  const ContentLoadFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}

// --- BLOC ---

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ContentBloc(this._repository) : super(ContentInitial()) {
    on<ContentLoad>(_onLoad);
  }

  final ContentRepositoryInterface _repository;

  Future<void> _onLoad(ContentLoad event, Emitter<ContentState> emit) async {
    try {
      emit(ContentLoadInProgress());
      final content = await _repository.getContentById(event.id);
      emit(ContentLoadSuccess(content: content));
    } catch (exception, stackTrace) {
      emit(ContentLoadFailure(exception: exception));
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



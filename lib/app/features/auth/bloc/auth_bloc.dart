// lib/app/features/auth/bloc/auth_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/auth/auth_repository_interface.dart';
import '../../../../di/di.dart';

// --- ОПРЕДЕЛЕНИЕ СОБЫТИЙ (Events) ---
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegister extends AuthEvent {
  const AuthRegister({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

// --- ОПРЕДЕЛЕНИЕ СОСТОЯНИЙ (States) ---
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object> get props => [userCredential];
}

final class AuthFailure extends AuthState {
  const AuthFailure({required this.exception});

  final Object exception;

  @override
  List<Object> get props => [exception];
}

// --- ОСНОВНОЙ КЛАСС BLOC ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryInterface authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthRegister>(_onRegister);
  }

  Future<void> _onRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final userCredential = await authRepository.registerWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(userCredential: userCredential));
    } catch (exception, stackTrace) {
      emit(AuthFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}



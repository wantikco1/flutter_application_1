// lib/app/features/auth/bloc/login_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/auth/auth_repository_interface.dart';
import '../../../../di/di.dart';

// --- EVENTS ---

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

// --- STATES ---

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object> get props => [userCredential];
}

final class LoginFailure extends LoginState {
  const LoginFailure({required this.exception});

  final Object exception;

  @override
  List<Object> get props => [exception];
}

// --- BLOC ---

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthRepositoryInterface _authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess(userCredential: userCredential));
    } catch (exception, stackTrace) {
      emit(LoginFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}



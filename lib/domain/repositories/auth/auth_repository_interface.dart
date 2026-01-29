// lib/domain/repositories/auth/auth_repository_interface.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRepositoryInterface {
  /// Регистрация пользователя по email и паролю.
  /// После успешной регистрации создает документ пользователя в Firestore.
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Вход пользователя по email и паролю.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Выход из учетной записи.
  Future<void> signOut();

  /// Стрим изменения состояния аутентификации.
  Stream<User?> authStateChanges();
}

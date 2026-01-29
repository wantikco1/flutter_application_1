// lib/domain/repositories/auth/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({
    required this.firebaseAuth,
    required this.firestore,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Регистрация пользователя в Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Создание документа пользователя в Firestore
      if (userCredential.user != null) {
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Ошибка при регистрации: $e');
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Ошибка при входе: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();
}

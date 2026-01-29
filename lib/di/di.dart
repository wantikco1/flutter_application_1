// lib/di/di.dart
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // [cite: 11]
import 'package:cloud_firestore/cloud_firestore.dart'; // [cite: 12]

import '../app/features/auth/bloc/auth_bloc.dart';
import '../app/features/auth/bloc/login_bloc.dart';
import '../app/features/content/bloc/content_bloc.dart';
import '../app/features/favorites/bloc/favorites_bloc.dart';
import '../app/features/home/bloc/home_block.dart';
import '../data/dio/set_up.dart';
import '../domain/repositories/auth/auth_repository.dart';
import '../domain/repositories/auth/auth_repository_interface.dart';
import '../domain/repositories/content/content_repository.dart';
import '../domain/repositories/content/content_repository_interface.dart';
import '../domain/repositories/favorite/favorite_repository.dart';
import '../domain/repositories/favorite/favorite_repository_interface.dart';

final getIt = GetIt.instance;
final Talker talker = TalkerFlutter.init();

Future<void> setupLocator() async {
  setUpDio();

  getIt
    ..registerSingleton<Talker>(talker)
    
    // Регистрация Firebase Auth для задач аутентификации [cite: 6, 11]
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    
    // Регистрация Cloud Firestore для работы с базой данных [cite: 6, 12]
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)

    ..registerLazySingleton<ContentRepositoryInterface>(
      () => ContentRepository(dio: dio),
    )
    ..registerLazySingleton<AuthRepositoryInterface>(
      () => AuthRepository(
        firebaseAuth: getIt(),
        firestore: getIt(),
      ),
    )
    ..registerLazySingleton<FavoriteRepositoryInterface>(
      () => FavoriteRepository(
        firestore: getIt(),
      ),
    )
    ..registerFactory<AuthBloc>(
      () => AuthBloc(getIt()),
    )
    ..registerFactory<LoginBloc>(
      () => LoginBloc(getIt()),
    )
    ..registerFactory<FavoritesBloc>(
      () => FavoritesBloc(getIt(), getIt()),
    )
    ..registerFactory<HomeBloc>(
      () => HomeBloc(getIt()),
    )
    ..registerFactory<ContentBloc>(
      () => ContentBloc(getIt()),
    );
}
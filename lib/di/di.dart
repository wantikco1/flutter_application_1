// lib/di/di.dart
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../app/features/content/bloc/content_bloc.dart';
import '../app/features/home/bloc/home_block.dart';
import '../data/dio/set_up.dart';
import '../domain/repositories/content/content_repository.dart';
import '../domain/repositories/content/content_repository_interface.dart';

final getIt = GetIt.instance;
final Talker talker = TalkerFlutter.init();

Future<void> setupLocator() async {
  setUpDio();

  getIt
    ..registerSingleton<Talker>(talker)
    ..registerLazySingleton<ContentRepositoryInterface>(
      () => ContentRepository(dio: dio),
    )
    ..registerFactory<HomeBloc>(
      () => HomeBloc(getIt()),
    )
    ..registerFactory<ContentBloc>(
      () => ContentBloc(getIt()),
    );
}
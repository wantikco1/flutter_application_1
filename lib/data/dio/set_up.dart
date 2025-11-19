// lib/data/dio/set_up.dart
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import '../../di/di.dart'; // Для talker

final Dio dio = Dio();

void setUpDio() {
  dio.options.baseUrl = 'https://dummyjson.com'; 

  dio.options.queryParameters.addAll({
    // 'api_token': '', // Ключ не нужен
  });

  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);
  dio.interceptors.addAll([
    TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
      ),
    ),
  ]);
}
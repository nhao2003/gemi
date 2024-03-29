import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:gemi/core/errors/data_source_exception.dart';
import '../../../model/gemini/gemini_safety/safety_setting.dart';
import '../../../model/gemini/generation_config/generation_config.dart';

/// [GeminiService] is api helper service class
class GeminiService {
  final Dio dio;
  final String apiKey;

  GeminiService(this.dio, {required this.apiKey});

  GenerationConfig? generationConfig;
  List<SafetySetting>? safetySettings;

  Future<Response> post(
    String route, {
    required Map<String, Object>? data,
    GenerationConfig? generationConfig,
    List<SafetySetting>? safetySettings,
    bool isStreamResponse = false,
  }) async {
    try {
      /// add local safetySettings or global safetySetting which added
      /// in [init] constructor
      if (safetySettings != null || this.safetySettings != null) {
        final listSafetySettings = safetySettings ?? this.safetySettings ?? [];
        final items = [];
        for (final safetySetting in listSafetySettings) {
          items.add(safetySetting.toJson());
        }
        data?['safetySettings'] = items;
      }

      /// add local generationConfig or global generationConfig which added
      /// in [init] constructor
      if (generationConfig != null || this.generationConfig != null) {
        data?['generationConfig'] =
            generationConfig?.toJson() ?? this.generationConfig?.toJson() ?? {};
      }
      return dio.post(
        route,
        data: jsonEncode(data),
        queryParameters: {'key': apiKey},
        options: Options(
            responseType:
                isStreamResponse == true ? ResponseType.stream : null),
      );
    } on DioException catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(
        message: e.message,
        statusCode: e.response?.statusCode.toString(),
        data: e.response?.data,
      );
    } catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(message: e.toString());
    }
  }

  Future<Response> get(String route) async {
    try {
      return dio.get(
        route,
        queryParameters: {'key': apiKey},
      );
    } on DioException catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(
        message: e.message,
        statusCode: e.response?.statusCode.toString(),
        data: e.response?.data,
      );
    } catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(message: e.toString());
    }
  }
}

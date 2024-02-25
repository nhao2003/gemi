import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_constanst.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source_impl.dart';
import 'package:gemi/data/data_source/remote/gemini_service/gemini_service.dart';
import 'package:gemi/data/model/gemini/candidate/candidate.dart';
import 'package:gemi/data/model/gemini/content/content.dart';
import 'package:gemi/data/model/gemini/gemini_model/gemini_model.dart';
import 'package:gemi/data/model/gemini/part/part.dart';
import 'package:test/test.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  final geminiRemoteDateSource = GeminiRemoteDataSourceImpl(
    service: GeminiService(
      Dio(BaseOptions(
        baseUrl: '${GeminiConstants.baseUrl}${GeminiConstants.defaultVersion}/',
        contentType: 'application/json',
      )),
      apiKey: dotenv.env['GEMINI_API_KEY']!,
    ),
  );
  group("GemiRemoteDataSource", () {
    test("should return list models correctly", () async {
      final response = await geminiRemoteDateSource.listModels();
      log(response.toString());
      expect(response, isA<List<GeminiModel>>());
      expect(response.isNotEmpty, true);
    });

    test("shoud return text generation correctly", () async {
      final response = await geminiRemoteDateSource.text(
        "Hello, how are you?",
      );
      log(response.toString());
      expect(response, isA<Candidate>());
      expect(response?.content, isNotNull);
      expect(response?.content?.parts, isA<List<Part>>());
      expect(response?.content?.parts?.isNotEmpty, true);
      expect(response?.content?.parts?.first.text, isNotEmpty);
    });

    test("shoud return text and image generation correctly", () async {
      final response = await geminiRemoteDateSource.textAndImage(
        text: "Hello, how are you?",
        images: [],
      );
      log(response.toString());
      expect(response, isA<Candidate>());
      expect(response?.content, isNotNull);
      expect(response?.content?.parts, isA<List<Part>>());
      expect(response?.content?.parts?.isNotEmpty, true);
      expect(response?.content?.parts?.first.text, isNotEmpty);
    });
  });
}

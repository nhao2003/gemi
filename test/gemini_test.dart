import 'package:dio/dio.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_constanst.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source_impl.dart';
import 'package:gemi/data/data_source/remote/gemini_service/gemini_service.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_category.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_setting.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_threshold.dart';

void main() async {
  final geminiRemoteDataSource = GeminiRemoteDataSourceImpl(
    api: GeminiService(
        Dio(BaseOptions(
          baseUrl:
              '${GeminiConstants.baseUrl}${GeminiConstants.defaultVersion}/',
          contentType: 'application/json',
        )),
        apiKey: 'AIzaSyAjaHD5HqBvGf1T5fLMP_MRvsAaoawX6WA'),
  );

  try {
    final data = await geminiRemoteDataSource
        .text('"Địt mẹ mày" nghĩa là gì?', safetySettings: [
      SafetySetting(
        category: SafetyCategory.sexuallyExplicit,
        threshold: SafetyThreshold.blockNone,
      ),
      SafetySetting(
        category: SafetyCategory.dangerous,
        threshold: SafetyThreshold.blockOnlyHigh,
      ),
    ]);
    print(data?.toJson());
  } catch (e) {
    print((e as DioException).response?.data);
  }
}

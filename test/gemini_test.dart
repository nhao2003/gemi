import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_constanst.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source_impl.dart';
import 'package:gemi/data/data_source/remote/gemini_service/gemini_service.dart';
import 'package:gemi/data/model/gemini/content/content.dart';
import 'package:gemi/data/model/gemini/part/part.dart';

void main() async {
  String filePath =
      "C:/Users/nhath/OneDrive - Trường ĐH CNTT - University of Information Technology/Ảnh/Giay To/20240217_140738.jpg";

  // Normalize the file path
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  final base64 = base64Encode(bytes);
  final service = GeminiService(
      Dio(BaseOptions(
        baseUrl: '${GeminiConstants.baseUrl}${GeminiConstants.defaultVersion}/',
        contentType: 'application/json',
      )),
      apiKey: 'AIzaSyAjaHD5HqBvGf1T5fLMP_MRvsAaoawX6WA');
  try {
    // List<Content> chats = [
    //   Content(
    //     parts: [
    //       Part(text: "Hello, My name is Hào."),
    //     ],
    //     role: Role.user,
    //   ),
    //   Content(
    //     parts: [
    //       Part(text: "Hello Hào, I'm Gemini."),
    //     ],
    //     role: Role.model,
    //   )
    // ];
    // 'https://generativelanguage.googleapis.com/v1beta/models/YOUR_MODEL:generateContent?key=YOUR_API_KEY';
    // final response = await service.post(
    //   "models/gemini-pro-vision:${GeminiConstants.defaultGenerateType}",
    //   data: {
    //     'contents': [
    //       // ...chats.map((e) => e.toJson()),
    //       {
    //         "parts": [
    //           {"text": "What is this image?"},
    //           {
    //             "inlineData": {
    //               "mimeType": "image/png",
    //               "data": base64,
    //             }
    //           }
    //         ],
    //         "role": "user"
    //       }
    //     ]
    //   },
    // );
    final remotedatasource = GeminiRemoteDataSourceImpl(api: service);
    final response = await remotedatasource.streamGenerateContent(
        'Viết đoạn văn nghị luận về tác hại của việc sử dụng điện thoại di động trong thời gian dài.');
    String str = "";
    await for (var value in response) {
      str += value!.content!.parts!.first.text;
      // Clear console
      print("\x1B[2J\x1B[0;0H");
      print(str);
    }
  } catch (e) {
    print((e as DioException).response?.data);
  }
}

import 'dart:developer';

import 'package:chat_gpt/helper/cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../const/constant.dart';

class OpenAiAPI {
  num totalTokens = 0;

  Future<String> generateResponse(String prompt) async {
    final key = CacheHelper.getData(key: "chat_bot_key");
    String openAPIKey = Const.API_KEY;
    if (key != null && key.toString().isNotEmpty) {
      openAPIKey = key;
    }
    log(openAPIKey);
    // String openAPIKey = "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";
    try {
      Dio dio = Dio(
        BaseOptions(
          baseUrl: "https://api.openai.com",
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $openAPIKey"},
          responseType: ResponseType.json,
        ),
      );

      final res = await dio.post("/v1/completions", data: {
        "model": "text-davinci-003",
        "prompt": prompt,
        "temperature": 0.0,
        "max_tokens": 150,
        "top_p": 1,
        "stop": [" Human:", " AI:"],
        "frequency_penalty": 0.0,
        "presence_penalty": 0.6
      });

      if (totalTokens >= 200) {
        totalTokens = 0;
      }
      totalTokens = totalTokens + (res.data["usage"]["total_tokens"] - res.data["usage"]["prompt_tokens"]);
      log(totalTokens.toString());
      return res.data['choices'][0]['text'];
    } on DioError {
      return "Error in API service. Please try again.";
    }
  }

  static tts(String text) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setPitch(0.8);
    await flutterTts.setSpeechRate(0.5);
    // await flutterTts.setLanguage("en-US");
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.stop();
    var result = await flutterTts.speak(text);
    return result;
  }
}

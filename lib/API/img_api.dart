import 'package:chat_gpt/const/constant.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/model/image_gen.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:dio/dio.dart';

class ImageGeneratorAPI {
  static Future<List<ImageGenModel>> generateImage(String prompt,
      [int count = 4]) async {
    final size = CacheHelper.getData(key: CacheKeys.imageSize) ?? "512x512";

    try {
      final key = CacheHelper.getData(key: "chat_bot_key");
      String openAPIKey = Const.API_KEY;
      if (key != null && key.toString().isNotEmpty) {
        openAPIKey = key;
      }
      Dio dio = Dio(BaseOptions(
          baseUrl: "https://api.openai.com/v1",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAPIKey"
          },
          receiveDataWhenStatusError: true));

      final response = await dio.post("/images/generations",
          data: {"prompt": prompt, "n": count, "size": size});

      List<ImageGenModel> images = List.from((response.data!['data'] as List)
          .map((e) => ImageGenModel.fromJson(e))
          .toList());
      return images;
    } on DioError catch (e) {
      print("ERROR:: ${e.response?.data}");
      return e.response!.data['error'];
    }
  }
}

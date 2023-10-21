import 'package:chat_gpt/const/constant.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio extactDio;
  static late Dio promptDio;

  static init() {
    extactDio = Dio(
      BaseOptions(
        baseUrl: 'https://api.api-ninjas.com/v1/imagetotext',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    promptDio.options.headers = {
      'Content-Type': 'application/json',
    };

    return await promptDio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required var data,
    Map<String, dynamic>? query,
  }) async {
    extactDio.options.headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': Const.EXTRACT_API_KEY,
    };

    return extactDio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}

import 'package:dio/dio.dart';

class AwsomePromptAPI {
  static const String _url =
      "https://datasets-server.huggingface.co/first-rows?dataset=fka%2Fawesome-chatgpt-prompts&config=fka--awesome-chatgpt-prompts&split=train";

  static Future<List<PromptItem>> awsomePrompt() async {
    final prmpt = await Dio().getUri(Uri.parse(_url));

    return List.from(
        (prmpt.data['rows'] as List).map((e) => PromptItem.fromJson(e['row'])));
  }
}

class PromptItem {
  String? act;
  String? prompt;

  PromptItem({this.act, this.prompt});

  PromptItem.fromJson(Map<String, dynamic> json) {
    act = json['act'];
    prompt = json['prompt'];
  }
}

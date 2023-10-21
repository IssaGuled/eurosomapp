import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt/API/api.dart';
import 'package:chat_gpt/chat/chat.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:flutter/services.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfConversationExport {
  static Future<File> exportChat(List<ChatInput> input) async {
    List<String> pdfNames = await CacheHelper.getStrings('names') ?? [];
    final pdf = Document();
    final f = await rootBundle.load('assets/logo.png');

    pdf.addPage(MultiPage(
        build: (context) => [
              pw.Padding(
                  padding: const pw.EdgeInsets.all(18),
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                            width: double.infinity,
                            padding: const pw.EdgeInsets.all(18),
                            color: input[index].type == ChatType.bot
                                ? PdfColors.white
                                : PdfColors.grey.shade(0.3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment:
                                  input[index].type == ChatType.user
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: <Widget>[
                                if (input[index].type == ChatType.bot)
                                  Container(
                                      width: 20,
                                      height: 20,
                                      child: pw.Image(pw.MemoryImage(
                                          f.buffer.asUint8List()))),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(input[index].text))
                              ],
                            ));
                      },
                      itemCount: input.length)),
            ]));
    String name = await OpenAiAPI()
        .generateResponse('give me an  short title for this ${input[1].text}');

    pdfNames.add(name.replaceAll('\n', ""));

    CacheHelper.setStrings('names', pdfNames);
    return await saveDoc(name.replaceAll('\n', ''), pdf);
  }

  static saveDoc(String name, Document doc) async {
    final bytes = await doc.save();

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name.pdf');
    file.writeAsBytes(bytes);
    log(file.path);
    return file;
  }

  static Future openPdfFile(File file) async {
    final path = file.path;
    await OpenFile.open(path);
  }

  static getPath(String name) async {
    final path = await getApplicationDocumentsDirectory();

    final paths = '${path.path}/$name.pdf';
    log(paths);

    await OpenFile.open(paths);
  }
}

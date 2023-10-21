import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/remote.dart';

class ImageAPI {
  Future<String> getImage(ImageSource source) async {
    String scannedText = '';
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: const Color(0xff2c2d37),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        FormData formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(croppedFile.path,
              filename: croppedFile.path.split('/').last,
              contentType: MediaType('image', 'png')),
          "type": "image/png"
        });

        scannedText = await extractImageText(formData);
      }
      return scannedText;
    } catch (e) {
      return "Continue?";
    }
  }

  List<String> strings = [];
  Future<String> extractImageText(data) async {
    final res = await DioHelper.postData(url: '/', data: data);
    strings = [];
    for (var i = 0; i < res.data.length; i++) {
      strings.add(res.data[i]['text']);
    }
    return strings.join(" ");
  }
}

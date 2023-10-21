class ImageGenModel {
  String? url;

  ImageGenModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}

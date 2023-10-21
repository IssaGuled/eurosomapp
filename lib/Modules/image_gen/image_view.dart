import 'package:chat_gpt/ads/banner.dart';
import 'package:chat_gpt/model/image_gen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../utils/components.dart';

class ImageView extends StatefulWidget {
  final List<ImageGenModel> images;
  const ImageView({Key? key, required this.images}) : super(key: key);

  @override
  State createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int currentPhoto = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  height: 30,
                  child: const Text("Download"),
                  onTap: () async {
                    final tempDir = await getTemporaryDirectory();
                    final path = '${tempDir.path}/${DateTime.now()}.png';
                    await Dio()
                        .download(widget.images[currentPhoto].url!, path);
                    GallerySaver.saveImage(path, toDcim: true).then((value) {
                      C.toast(msg: "Downloaded");
                    });
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: PhotoViewGallery.builder(
        onPageChanged: (index) {
          setState(() {
            currentPhoto = index;
          });
        },
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index].url!),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(
                tag: widget.images[index].url!.substring(10, 15)),
          );
        },
        itemCount: widget.images.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        // backgroundDecoration: widget.backgroundDecoration,
        // pageController: widget.pageController,
        // onPageChanged: onPageChanged,
      ),
      //bottomNavigationBar:BoxAd(),
    );
  }
}

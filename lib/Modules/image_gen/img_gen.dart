import 'dart:io';

import 'package:chat_gpt/API/img_api.dart';
import 'package:chat_gpt/Modules/image_gen/image_view.dart';
import 'package:chat_gpt/ads/banner.dart';
import 'package:chat_gpt/model/image_gen.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:chat_gpt/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../ads/ad_helper.dart';
import '../../helper/cache.dart';
import '../../main.dart';
import '../../resources/cache_keys.dart';
import '../../resources/images.dart';
import '../../utils/textform.dart';
import '../subscription/subs.dart';

class ImgGen extends StatefulWidget {
  const ImgGen({Key? key}) : super(key: key);

  @override
  State createState() => _ImgGenState();
}

class _ImgGenState extends State<ImgGen> {
  final TextEditingController _controller = TextEditingController();
  bool isSearching = false;
  List<ImageGenModel> images = [];
  int numOfgen = CacheHelper.getData(key: CacheKeys.numberOfGeneration) ?? 0;

  // static final AdRequest request = AdRequest(
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );

  // InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    // InterstitialAd.load(
    //     adUnitId: Platform.isAndroid
    //         ? 'ca-app-pub-3940256099942544/1033173712'
    //         : 'ca-app-pub-3940256099942544/1033173712',
    //     request: request,
    //     adLoadCallback: InterstitialAdLoadCallback(
    //       onAdLoaded: (InterstitialAd ad) {
    //         print('$ad loaded');
    //         _interstitialAd = ad;
    //         _numInterstitialLoadAttempts = 0;
    //         _interstitialAd!.setImmersiveMode(true);
    //       },
    //       onAdFailedToLoad: (LoadAdError error) {
    //         print('InterstitialAd failed to load: $error.');
    //         _numInterstitialLoadAttempts += 1;
    //         _interstitialAd = null;
    //         if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
    //           _createInterstitialAd();
    //         }
    //       },
    //     ));
  }

  // _showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //   );
  //   _interstitialAd!.show();
  //   _interstitialAd = null;
  // }

  @override
  void initState() {
    // _createInterstitialAd();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.hardColor,
        title: Text(
          'Image Generator',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      backgroundColor: AppColors.solfColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage(Images.background))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DefTextForm(
                  controller: _controller,
                  hintText: "Enter a brief of image",
                  onSubmitted: (value) async {
                    if (numOfgen < 5) {
                      numOfgen++;
                      images.clear();
                      setState(() {
                        isSearching = true;
                      });
                      final imagess = await ImageGeneratorAPI.generateImage(_controller.text.trim());
                      images.addAll(imagess);
                      setState(() {
                        isSearching = false;
                      });
                      await CacheHelper.saveData(key: CacheKeys.numberOfGeneration, value: numOfgen);
                    } else {
                      showalertbox();
                      // C.snack("You can only generate 3 images a day", context);
                    }
                  }),
              if (images.isNotEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                C.navTo(
                                    context,
                                    ImageView(
                                      images: images,
                                    ));
                              },
                              child: Container(
                                width: 50,
                                height: 100,
                                decoration: BoxDecoration(color: AppColors.cayanColor, borderRadius: BorderRadius.circular(12)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  images[index].url!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Container(
                                      width: 50,
                                      height: 100,
                                      color: AppColors.cayanColor,
                                    );
                                  },
                                ),
                              ));
                        },
                        itemCount: images.length,
                      )),
                ),
              if (isSearching) Lottie.asset('assets/searching.json'),
              if (!isSearching && images.isEmpty) Lottie.asset('assets/nosearch.json'),
              if (!isSearching && images.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "Enter a brief of image you want and AI will generate the image based on your imagination!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 18),
                  ),
                )
            ],
          ),
        ),
      ),
      //bottomNavigationBar: BoxAd(),
    );
  }

  void showalertbox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
              )
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.solfColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Get Images",
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Please keep on eye tokens and top onetime",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  //  Get.to(MyApp());
                },
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      color: AppColors.hardColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.hardColor,
                          // blurRadius: 15.0, // soften the shadow
                          spreadRadius: 4.0, //extend the shadow
                          offset: Offset(
                            0.0,
                            2.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                      gradient: LinearGradient(colors: [
                        AppColors.solfColor,
                        AppColors.solfColor,
                      ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Get Unlimited Chat",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    ))),
            SizedBox(
              height: 40,
            ),
            // InkWell(
            //     onTap: () async {
            //       _showInterstitialAd();
            //
            //       numOfgen = 0;
            //       CacheHelper.saveData(
            //           key: CacheKeys.numberOfGeneration, value: 0);
            //       Get.back();
            //     },
            //     child: Container(
            //         height: 50,
            //         width: MediaQuery.of(context).size.width / 1.150,
            //         decoration: BoxDecoration(
            //           color: AppColors.hardColor,
            //           boxShadow: [
            //             BoxShadow(
            //               color: AppColors.hardColor,
            //               // blurRadius: 15.0, // soften the shadow
            //               spreadRadius: 4.0, //extend the shadow
            //               offset: Offset(
            //                 0.0,
            //                 2.0, // Move to bottom 5 Vertically
            //               ),
            //             )
            //           ],
            //           gradient: LinearGradient(colors: [
            //             AppColors.solfColor,
            //             AppColors.solfColor,
            //           ]),
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Center(
            //           child: Text(
            //             "Watch Ads",
            //             style: GoogleFonts.poppins(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.white),
            //           ),
            //         ))),
            // SizedBox(
            //   height: 40,
            // ),
          ],
        );
      },
    );
  }
}
/**
 *
 */

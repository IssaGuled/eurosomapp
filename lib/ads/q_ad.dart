// import 'dart:developer';
// import 'dart:io';
//
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import 'ad_helper.dart';
//
// class QestionAd {
//   static InterstitialAd? _ad;
//   static bool isAddReady = false;
//
//   static void loadSaveAd() {
//     InterstitialAd.load(
//         adUnitId: Platform.isAndroid
//              ? '		ca-app-pub-3940256099942544/1033173712'
//              : '		ca-app-pub-3940256099942544/1033173712',
//         // adUnitId: Platform.isAndroid
//         //     ? 'ca-app-pub-3940256099942544/1033173712'
//         //     : 'ca-app-pub-3940256099942544/4411468910',
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             isAddReady = true;
//             _ad = ad;
//           },
//           onAdFailedToLoad: (error) {
//             log(error.toString());
//           },
//         ));
//   }
//
//   static void showSaveAd() {
//     if (isAddReady) {
//       _ad!.show();
//     }
//   }
// }

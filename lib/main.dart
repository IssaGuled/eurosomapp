import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/Modules/home/Home_intro.dart';
import 'package:chat_gpt/Modules/subscription/inapp_purchase_controller.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/helper/remote.dart';
import 'package:chat_gpt/helper/remote_config_manager.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:chat_gpt/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'Modules/home/chat_screen.dart';
import 'auth/loginPage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'authbackend/user_model.dart';
import 'subscription_page.dart';

// AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
//     StreamController<ReceivedNotification>.broadcast();
//
// final StreamController<String?> selectNotificationStream =
//     StreamController<String?>.broadcast();
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // await setupFlutterNotifications();
//   // showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    Stripe.publishableKey = 'pk_live_51Msne5CH5lT2MzhpnnaNsbItdj2rZ69jZwdhKNtM2nb5xokrw8x10t8OaxWZyBMfM8cXAstFSuwNEVI8bXlAYXSc00ePAQsm2I';
    //Stripe.merchantIdentifier = 'com.eurosom"';
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    // MobileAds.instance.initialize();
    await Stripe.instance.applySettings();
    await DioHelper.init();
    await CacheHelper.init();
    // await
    // MobileAds.instance.initialize();
    final DateFormat dateFormat = DateFormat("yyyy-mm-dd");
    final today = int.parse(dateFormat.format(DateTime.now()).split("-").join());
    final cachedDate = await CacheHelper.getData(key: CacheKeys.todaysDate) ?? 0;
    if (today > cachedDate) {
      CacheHelper.removeData(CacheKeys.numberOfQestions);
      CacheHelper.removeData(CacheKeys.numberOfGeneration);
    }
    // String? stringValue;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // stringValue = prefs.getString('email');
    // print(stringValue);
    await RemoteConfigManager().init();
  } catch (e) {
    print("ERROR:: ${e.toString()}");
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class Classes1 extends StatefulWidget {
  const Classes1({Key? key}) : super(key: key);

  @override
  State<Classes1> createState() => _Classes1State();
}

class _Classes1State extends State<Classes1> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel userModel = Get.put(UserModel());

  getProfile() async {
    await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      userModel.username = value.data()!['username'];
      userModel.useremail = value.data()!['useremail'];
      userModel.purchased = value.data()!['purchased'];
      // userModel.profileUrl = value.data()!['profileUrl'];
      // update();
      print(userModel.useremail = value.data()!['useremail']);
    });
  }

  @override
  void initState() {
    setState(() {
      getProfile();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getProfile();

    return Scaffold(
      body: userModel.purchased == false ? SubscriptionPage() : Homepage(),
    );
  }
}

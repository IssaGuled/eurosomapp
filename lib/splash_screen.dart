import 'dart:io';

import 'package:chat_gpt/Modules/home/Home_intro.dart';
import 'package:chat_gpt/Modules/subscription/whatsapp_subscription_dialog.dart';
import 'package:chat_gpt/auth/loginPage.dart';
import 'package:chat_gpt/subscription_page.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/helper/remote_config_manager.dart';
import 'package:chat_gpt/resources/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Images.logo,
          width: Get.width * .7,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  void _redirectUser() {
    FirebaseFirestore.instance.collection('apikeys').doc('key').get().then(
          (value) => CacheHelper.saveData(
            key: "chat_bot_key",
            value: "${value.data()?['key']}",
          ),
        );
    Future.delayed(Duration(milliseconds: 1500), () {
      if (FirebaseAuth.instance.currentUser != null) {
        if (RemoteConfigManager().isTestEnvEnabled) {
          Get.offAll(() => Homepage());
        } else {
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
            final isPurchased = value.data()!['purchased'] ?? false;
            final isMonthly = value.data()!['isMonthly'] ?? true;
            final purchasedAt = value.data()!['purchasedAt'];
            if (isPurchased) {
              if (purchasedAt != null) {
                final date = DateTime.parse(purchasedAt);
                final days = isMonthly ? 30 : 360;
                if (DateTime.now().difference(date).inDays <= days) {
                  Get.to(() => Homepage());
                } else {
                  Get.to(() => SubscriptionPage());
                }
              } else {
                Get.to(() => Homepage());
              }
            } else {
              if (value.data()?['tokens'] != '0') {
                Get.to(() => Homepage());
              }else{
                Get.to(() => SubscriptionPage());
              }
            }
          });
        }
      } else {
        Get.offAll(() => LoginPage());
      }
    });
  }
}

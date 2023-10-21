import 'package:chat_gpt/auth/loginPage.dart';
import 'package:chat_gpt/authbackend/user_model.dart';
import 'package:chat_gpt/resources/Toast.dart';
import 'package:chat_gpt/subscription_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Modules/home/Home_intro.dart';

class LoginSignupController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel userModel = Get.put(UserModel());
  TextEditingController forgetpassword = TextEditingController();
  TextEditingController usernamecntrlr = TextEditingController();
  TextEditingController emailcntrlr = TextEditingController();
  TextEditingController phonecntlr = TextEditingController();
  TextEditingController passwordctlr = TextEditingController();
  TextEditingController reffCode = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  //bolean
  void onReady() {
    if (FirebaseAuth.instance.currentUser != null) {
      getProfile();
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();
  var signinloading = false.obs;
  var signuploading = false.obs;

  Future<void> SignUp() async {
    signuploading.value = true;
    try {
      var user = await auth.createUserWithEmailAndPassword(email: emailcntrlr.text, password: passwordctlr.text);
      if (user.additionalUserInfo!.isNewUser) {
        userModel.username = usernamecntrlr.text;
        userModel.useremail = emailcntrlr.text;
        userModel.phone = phonecntlr.text;
        userModel.password = passwordctlr.text;
        userModel.id = auth.currentUser!.uid;
        userModel.timeagoe = "${DateTime.now().toString()}";
        userModel.purchased = false;
        userModel.ref = reffCode.text;
        userModel.package = "Stripe";
        userModel.tokens = '3';
        if (user != null) {
          await firestore.collection("users").doc(auth.currentUser!.uid).set(
                userModel.fromjson(),
              );
          Get.to(() => LoginPage());
        }
        signuploading.value = false;
      }
    } catch (e) {
      AmeToast.toast("${'Invalid Email Adress'}");
      signuploading.value = false;
    }
  }

  Future<void> signIn() async {
    signinloading.value = true;

    try {
      await auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      final userRef = FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid);
      final user = await userRef.get();
      if ((user.data()?['session'] ?? false) == true) {
        AmeToast.toast("Please logout from another device first.");
        auth.signOut();
      } else {
        final isPurchased = user.data()!['purchased'] ?? false;
        final isMonthly = user.data()!['isMonthly'] ?? true;
        final purchasedAt = user.data()!['purchasedAt'];
        if (isPurchased) {
          if (purchasedAt != null) {
            final date = DateTime.parse(purchasedAt);
            final days = isMonthly ? 30 : 360;
            if (DateTime.now().difference(date).inDays <= days) {
              Get.offAll(() => Homepage());
            } else {
              Get.offAll(() => SubscriptionPage());
            }
          } else {
            Get.offAll(() => Homepage());
          }
        } else {
          if (user.data()?['tokens'] != '0') {
            Get.offAll(() => Homepage());
          } else {
            Get.to(() => SubscriptionPage());
          }
        }
        userRef.update({'session': true});
      }
      signinloading.value = false;
    } on FirebaseAuthException catch (e) {
      AmeToast.toast("${e.message}");
      signinloading.value = false;
    }
  }

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email.text.trim());
    print(prefs);
  }

  getProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      userModel.username = value.data()!['username'];
      update();
      userModel.useremail = value.data()!['useremail'];
      update();
      userModel.purchased = value.data()!['purchased'];
      update();
      // userModel.profileUrl = value.data()!['profileUrl'];
      // update();
      print(userModel.useremail = value.data()!['useremail']);
    });
  }

  Future<void> googleSignup() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        print(googleSignInAccount.email);
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        if (userCredential.additionalUserInfo!.isNewUser) {
          userModel.useremail = googleSignInAccount.email;
          userModel.username = googleSignInAccount.displayName;
          userModel.id = auth.currentUser!.uid;
          userModel.timeagoe = "${DateTime.now().toString()}";
          userModel.purchased = false;
          userModel.package = "Stripe";
          userModel.tokens = '3';
          firestore.collection("users").doc(auth.currentUser!.uid).set(userModel.fromjson());
          AmeToast.sucesstoast("Login Successfully");
          print("users${userModel.purchased}");
          // if (RemoteConfigManager().isTestEnvEnabled) {
          Get.offAll(() => Homepage());
          // } else {
          //   Get.offAll(subscriptionzz());
          // }
        } else {
          // if (RemoteConfigManager().isTestEnvEnabled) {
          Get.offAll(() => Homepage());
          // } else {
          //   await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get().then((value) {
          //     value.data()!['purchased'] ? Get.offAll(Homepage()) : Get.offAll(subscriptionzz());
          //   });
          // }
        }
      }
    } catch (error) {
      // AmeToast.toast("$error");
      print(error);
    }
  }

  Future<void> appleSignIn() async {
    try {
      // final appleSignInAcc = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );
      // if (appleSignInAcc.identityToken != null) {
      //   AuthCredential credential = AppleAuthProvider.credential(appleSignInAcc.identityToken!);
      //   final UserCredential userCredential = await auth.signInWithCredential(credential);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(AppleAuthProvider());
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel.useremail = userCredential.user?.email;
        userModel.username = userCredential.user?.displayName;
        userModel.id = auth.currentUser!.uid;
        userModel.timeagoe = "${DateTime.now().toString()}";
        userModel.purchased = false;
        userModel.package = "Stripe";
        userModel.tokens = '3';
        firestore.collection("users").doc(auth.currentUser!.uid).set(userModel.fromjson());
        AmeToast.sucesstoast("Login Successfully");
        print("users${userModel.purchased}");
        // if (RemoteConfigManager().isTestEnvEnabled) {
        Get.offAll(() => Homepage());
        // } else {
        //   Get.offAll(subscriptionzz());
        // }
      } else {
        // if (RemoteConfigManager().isTestEnvEnabled) {
        Get.offAll(() => Homepage());
        // } else {
        //   await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get().then((value) {
        //     value.data()!['purchased'] ? Get.offAll(Homepage()) : Get.offAll(subscriptionzz());
        //   });
        // }
      }
      // }
    } catch (error) {
      // AmeToast.toast("$error");
      print(error);
    }
  }

  Future<void> forget() async {
    auth.sendPasswordResetEmail(email: forgetpassword.text);
  }
}

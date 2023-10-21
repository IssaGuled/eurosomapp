import 'package:chat_gpt/auth/SingupPage.dart';
import 'package:chat_gpt/authbackend/login_signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/Toast.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import 'forgetpassword.dart';

class LoginPage extends GetView<LoginSignupController> {
  final userModeView = Get.put(LoginSignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.solfColor,
      body: Obx(
        () => LoadingOverlay(
          isLoading: userModeView.signinloading.value,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 48),
                  Image.asset(
                    Images.logo,
                    height: 150,
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width * .7,
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.solfColor,
                        AppColors.solfColor,
                      ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                      controller: userModeView.email,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) {
                        userModeView.email.text = v.trim();
                        userModeView.email.selection = TextSelection(
                          baseOffset: userModeView.email.text.length,
                          extentOffset: userModeView.email.text.length,
                        );
                      },
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(242, 242, 242, 0.74),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: "Enter email",
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.solfColor,
                        AppColors.solfColor,
                      ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                      controller: userModeView.password,
                      onChanged: (v) {
                        userModeView.password.text = v.trim();
                        userModeView.password.selection = TextSelection(
                          baseOffset: userModeView.password.text.length,
                          extentOffset: userModeView.password.text.length,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: Color.fromRGBO(242, 242, 242, 0.74),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "Password",
                          border: InputBorder.none,
                          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300, color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      if (userModeView.email.text.isEmpty) {
                        AmeToast.toast("Please Enter your Email");
                      } else if (userModeView.password.text.isEmpty) {
                        AmeToast.toast("Please Enter your password");
                      } else {
                        userModeView.signIn();

                        userModeView.addStringToSF();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.150,
                      decoration: BoxDecoration(
                        color: Color(0xff1877F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => Forgetpassword());
                        },
                        child: Text(
                          "Forget Password?",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.withOpacity(.3))),
                      SizedBox(width: 24),
                      Text(
                        "OR",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Color(0xff1877F2),
                            ),
                      ),
                      SizedBox(width: 24),
                      Expanded(child: Divider(color: Colors.grey.withOpacity(.3))),
                    ],
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      userModeView.googleSignup();
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 1.150,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20),
                          Image.asset(
                            "assets/images/google_img.png",
                            color: Colors.white,
                            height: 20,
                          ),
                          SizedBox(width: 8),
                          Center(
                            child: Text(
                              "Continue with Google",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () => controller.appleSignIn(),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 1.150,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20),
                          Icon(
                            Icons.apple,
                            size: 24,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Center(
                            child: Text(
                              "Sign in with Apple",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet.?",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(SingUpPage());
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "By using this app you agree to \n",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "Terms and Conditions.",
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrl(
                                    Uri.parse("https://eurosom.com/terms-and-condition.html"),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

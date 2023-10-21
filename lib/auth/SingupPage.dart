import 'package:chat_gpt/auth/loginPage.dart';
import 'package:chat_gpt/authbackend/login_signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/Toast.dart';
import '../resources/colors.dart';
import '../resources/images.dart';

class SingUpPage extends GetView<LoginSignupController> {
  final LoginSignupController userModeView = Get.put(LoginSignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.solfColor,
      body: Obx(
        () => LoadingOverlay(
          isLoading: userModeView.signuploading.value,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      controller: userModeView.usernamecntrlr,
                      textInputAction: TextInputAction.next,
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
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "User Name",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      controller: userModeView.emailcntrlr,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) {
                        userModeView.emailcntrlr.text = v.trim();
                        userModeView.emailcntrlr.selection = TextSelection(
                          baseOffset: userModeView.emailcntrlr.text.length,
                          extentOffset: userModeView.emailcntrlr.text.length,
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
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      controller: userModeView.phonecntlr,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) {
                        userModeView.phonecntlr.text = v.trim();
                        userModeView.phonecntlr.selection = TextSelection(
                          baseOffset: userModeView.phonecntlr.text.length,
                          extentOffset: userModeView.phonecntlr.text.length,
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
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "Phone",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      controller: userModeView.passwordctlr,
                      textInputAction: TextInputAction.next,
                      onChanged: (v) {
                        userModeView.passwordctlr.text = v.trim();
                        userModeView.passwordctlr.selection = TextSelection(
                          baseOffset: userModeView.passwordctlr.text.length,
                          extentOffset: userModeView.passwordctlr.text.length,
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
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "Password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      controller: userModeView.reffCode,
                      onChanged: (v) {
                        userModeView.reffCode.text = v.trim();
                        userModeView.reffCode.selection = TextSelection(
                          baseOffset: userModeView.reffCode.text.length,
                          extentOffset: userModeView.reffCode.text.length,
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
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "Agent No",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      if (userModeView.usernamecntrlr.text.isEmpty) {
                        AmeToast.toast("Please Enter your FullName");
                      } else if (userModeView.emailcntrlr.text.isEmpty) {
                        AmeToast.toast("Please Enter your Email");
                      } else if (userModeView.phonecntlr.text.isEmpty) {
                        AmeToast.toast("Please Enter your Phone");
                      } else if (userModeView.passwordctlr.text.isEmpty) {
                        AmeToast.toast("Please Enter your password");
                      } else {
                        userModeView.SignUp();
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
                          "Sign Up ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(() => LoginPage());
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      )
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

import 'package:chat_gpt/authbackend/login_signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/colors.dart';
import '../resources/images.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({Key? key}) : super(key: key);

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  LoginSignupController userModeView = Get.put(LoginSignupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          // mainAxisAlignment:MainAxisAlignment.center,
          // crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Image.asset(
              Images.logo,
              height: 350,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            Container(
              // height: 50,
              width: MediaQuery.of(context).size.width / 1.150,
              decoration: BoxDecoration(
                // color: AppColors.hardColor,

                gradient: LinearGradient(colors: [
                  AppColors.solfColor,
                  AppColors.solfColor,
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
                ),
                controller:userModeView.forgetpassword,
                decoration: InputDecoration(
                    fillColor: Color.fromRGBO(242, 242, 242, 0.74),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "Email",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.black)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                userModeView.forget();
                Get.back();
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
                  "Forget Password ",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

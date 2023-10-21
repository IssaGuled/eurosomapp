import 'dart:io';

import 'package:chat_gpt/auth/loginPage.dart';
import 'package:chat_gpt/const/robot_icons.dart';
import 'package:chat_gpt/resources/Toast.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:chat_gpt/resources/style.dart';
import 'package:chat_gpt/utils/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsBottomSheet extends StatelessWidget {
  final bool isVoiceEnabled;
  final Function(bool)? onToggle;
  final Function()? onClear;

  const SettingsBottomSheet({super.key, required this.isVoiceEnabled, this.onToggle, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: SettingsList(
        physics: const AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        // platform: DevicePlatform.iOS,
        lightTheme: const SettingsThemeData(
          titleTextColor: Colors.white,
          settingsListBackground: AppColors.hardColor,
          settingsSectionBackground: AppColors.solfColor,
        ),
        sections: [
          // CustomSettingsSection(
          //     child: Padding(
          //   padding: const EdgeInsets.only(top: 30),
          //   child: Column(
          //     children: [
          //       Text(
          //         "Settings",
          //         style: GoogleFonts.poppins(
          //             fontSize: 20,
          //             fontWeight: FontWeight.w300,
          //             color: Colors.black),
          //       ),
          //       Image.asset(
          //         Images.logo,
          //         height: 100,
          //         width: 200,
          //         fit: BoxFit.cover,
          //       ),
          //
          //       // Image.asset("assets/images/logo.png")
          //     ],
          //   ),
          // )),
          SettingsSection(
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    C.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  'Settings'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ],
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.language,
                  color: Colors.black,
                ),
                title: Text(
                  'Language',
                  style: AppStyle.normal(),
                ),
                value: Text(
                  'English',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) {
                  C.toast(msg: "Multi-Language Soon");
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  'Clear Conversation',
                  style: AppStyle.normal(),
                ),
                // value: const Text('English'),
                onPressed: (context) {
                  if (onClear != null) onClear!();
                  C.pop(context);
                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  // isVoiceEnabled = value;
                  if (onToggle != null) onToggle!(value);
                  C.pop(context);
                },
                initialValue: isVoiceEnabled,
                leading: const Icon(
                  Robot.robot,
                  color: Colors.black,
                ),
                title: Text(
                  'Bot Voice',
                  style: AppStyle.normal(),
                ),
              ),
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.subscriptions_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  'log out',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).update({
                    'session': false,
                  });
                  var user = await auth.signOut();

                  Get.to(() => LoginPage());
                },
              ),
            ],
          ),
          SettingsSection(
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.lock_open, color: Colors.black),
                title: Text(
                  'Privacy Policy',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) async {
                  final url = Uri.parse("https://www.privacypolicygenerator.info/live.php?token=T2aySwXP0xZX954RS22YdmxZPFKl6vKM");
                  if (!await launchUrl(
                    url,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.help_outline,
                  color: Colors.black,
                ),
                title: Text(
                  'Help',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) async {
                  final url = Uri.parse(
                      "https://sites.google.com/view/censorai/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9");
                  if (!await launchUrl(
                    url,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.no_accounts,
                  color: Colors.black,
                ),
                title: Text(
                  'Delete Account',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) async {
                  Get.defaultDialog(
                    title: "Account Deletion",
                    middleText: "Are you sure you want to delete an account?",
                    textCancel: "No",
                    textConfirm: "Yes",
                    confirmTextColor: Colors.white,
                    onConfirm: () async {
                      await FirebaseAuth.instance.currentUser?.delete();
                      Get.offAll(() => LoginPage());
                      AmeToast.sucesstoast("Your account has been deleted successfully!");
                    },
                  );
                },
              ),
            ],
            title: Text(
              'Support'.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 2),
            ),
          ),
          SettingsSection(
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.info_outline,
                  color: Colors.black,
                ),
                title: Text(
                  'About us',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) async {
                  final url = Uri.parse(
                      "https://sites.google.com/view/censorai/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9");
                  if (!await launchUrl(
                    url,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(
                  Icons.star_border,
                  color: Colors.black,
                ),
                title: Text(
                  'Rate Us',
                  style: AppStyle.normal(),
                ),
                onPressed: (context) async {
                  if (Platform.isAndroid) {
                    final url = Uri.parse("https://play.google.com/store/apps/details?id=com.eurosom");
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $url');
                    }
                  } else {
                    final url = Uri.parse("https://apps.apple.com/us/app/telegram-messenger/id686449807");
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $url');
                    }
                  }
                },
              ),
            ],
            title: Text(
              'about'.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

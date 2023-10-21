import 'package:chat_gpt/authbackend/user_model.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/helper/remote_config_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppSubscriptionDialog extends StatelessWidget {
  final UserModel user;

  const WhatsAppSubscriptionDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Token Expired!",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                InkWell(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(Icons.clear),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[500]),
            SizedBox(height: 8),
            Text(
              "You are running out of token!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please contact support for token details on below WhatsApp channel.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _openWhatsApp,
                  child: Image.asset(
                    "assets/images/ic_whatsapp.png",
                    height: 54,
                  ),
                ),
                SizedBox(width: 24),
                InkWell(
                  onTap: _dialCall,
                  child: CircleAvatar(radius: 28, child: Icon(Icons.call)),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _openWhatsApp() {
    print("REMOTE:: ${RemoteConfigManager().whatsAppNumber}");
    FlutterLaunch.launchWhatsapp(
      phone: "${RemoteConfigManager().whatsAppNumber}",
      message:
          "Hello Team Eurosom,\nI am running out of token. Please refill my tokens!\n\nName: ${user.username??''}\nEmail: ${user.useremail??''}\n\nThank You!",
    );
    // launchUrl(Uri.parse("https://wa.me/${RemoteConfigManager().whatsAppNumber}"));
    // final groupInviteLink = "https://chat.whatsapp.com/DllKh8sY1x0ENOIpryhjaG";
    // launchUrl(Uri.parse(groupInviteLink));
  }

  void _dialCall() {
    launchUrl(Uri.parse("tel://${RemoteConfigManager().dialNumber}"));
  }
}

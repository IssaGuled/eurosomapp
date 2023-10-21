import 'package:chat_gpt/API/awsome_prmpt.dart';
import 'package:chat_gpt/ads/banner.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/chat_screen.dart';

class AwsomePrompt extends StatefulWidget {
  const AwsomePrompt({Key? key}) : super(key: key);

  @override
  State createState() => _AwsomePromptState();
}

class _AwsomePromptState extends State<AwsomePrompt> {
  @override
  void initState() {
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
        elevation: 10,
        title: Text(
          'Awsome Prompts',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColors.hardColor,
      ),
      backgroundColor: AppColors.solfColor,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<PromptItem>>(
            future: AwsomePromptAPI.awsomePrompt(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scrollbar(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return awsomePromptBuilder(snapshot.data![index]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: snapshot.data!.length),
                );
              } else {
                return const Center(
                    child: SpinKitThreeBounce(
                  color: Colors.cyan,
                  size: 20,
                ));
              }
            },
          )),
     // bottomNavigationBar: BoxAd(),
    );
  }

  Widget awsomePromptBuilder(PromptItem p) => Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: InkWell(
          onTap: () {
            Get.to(ChatScreen(
              color: Color(0xffE0DFFE),
              fieldtext:"How can I help you with AwesomePrompt?",
              prompt: p.prompt,
              act: p.act,
            ));
          },
          onLongPress: () {
            HapticFeedback.heavyImpact();
            Clipboard.setData(ClipboardData(text: p.prompt!));
            Fluttertoast.showToast(msg: "Copied");
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.solfColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    p.act!,
                    style:GoogleFonts.poppins(fontWeight:FontWeight.w500,color:Colors.black,fontSize:16),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      p.prompt!,
                      style:GoogleFonts.poppins(fontWeight:FontWeight.w500,color:Colors.black,fontSize:14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

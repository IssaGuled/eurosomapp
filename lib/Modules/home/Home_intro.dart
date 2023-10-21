import 'package:chat_gpt/Modules/home/settings_bottomsheet.dart';
import 'package:chat_gpt/Modules/prompts/prompt.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/images.dart';
import '../image_gen/img_gen.dart';
import 'chat_screen.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.hardColor,
                isScrollControlled: true,
                builder: (context) => SettingsBottomSheet(
                  isVoiceEnabled: false,
                  onClear: () {
                    // chat.clear();
                    // allPrompt = '';
                    // chats.clear();
                    // chatText.clear();
                    // animated.clear();
                  },
                  onToggle: (value) {
                    // isVoiceEnabled = value;
                  },
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              color: Colors.indigo,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: DoubleBack(
        message: "Tap again to exit",
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    Images.logo,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome!",
                  style: GoogleFonts.inter(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  "How can I help you!",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.black.withOpacity(.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                decoration: BoxDecoration(
                                  boxShadow: [],
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff212559),
                                      Color(0xff212559),
                                      Color(0xff212559),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  color: Color(0xff212559),
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xff212559),
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                fieldtext: "Ask questions effortlessly",
                                act:
                                    "You are a knowledgeable assistant capable of answering a wide range of questions. Respond with accurate and informative answers on various topics, including science, history, technology, current events, and more. Provide helpful explanations and relevant details to satisfy users' curiosity and expand their knowledge.",
                                color: Color(0xff212559),
                                prompt:
                                    "You are a knowledgeable assistant capable of answering a wide range of questions. Respond with accurate and informative answers on various topics, including science, history, technology, current events, and more. Provide helpful explanations and relevant details to satisfy users' curiosity and expand their knowledge.",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff22255a),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              "Ask questions effortlessly",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImgGen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff15287a),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              "Generate impressive art",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                decoration: BoxDecoration(
                                  boxShadow: [],
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff182D88),
                                      Color(0xff182D88),
                                      Color(0xff182D88),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    width: 4,
                                    color: Color(0xff182D88),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                act:
                                    "You are an expert coder proficient in multiple programming languages. Provide detailed responses on coding, programming concepts, algorithms, debugging, software architecture, and best practices. Offer helpful suggestions, tips, and examples to assist users in their coding journey.",
                                fieldtext: "How can I help you with coding?",
                                color: Color(0xff182D88),
                                prompt:
                                    "You are an expert coder proficient in multiple programming languages. Provide detailed responses on coding, programming concepts, algorithms, debugging, software architecture, and best practices. Offer helpful suggestions, tips, and examples to assist users in their coding journey.",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff292fa8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          // width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              "Learn coding with ease",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                decoration: BoxDecoration(
                                  boxShadow: [],
                                  gradient: LinearGradient(
                                    colors: [Color(0xff006bb4), Color(0xff006bb4), Color(0xff006bb4)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fieldtext: "Share whatever you wish.",
                                color: Color(0xff006bb4),
                                act:
                                    "You are a friendly and empathetic companion who offers support and advice. Act as a trustworthy friend or counselor, providing a listening ear and guidance on various topics. Offer encouragement, understanding, and practical suggestions to help users navigate their challenges and improve their well-being",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2e59c6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              "Conversations without limitations",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AwsomePrompt()));
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xff2e4d99),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "Check Out Eurosom!",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

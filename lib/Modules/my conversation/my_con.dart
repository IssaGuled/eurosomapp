import 'package:chat_gpt/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../API/export_conversation.dart';

class MyConversations extends StatefulWidget {
  final List<String> chats;
  const MyConversations({Key? key, required this.chats}) : super(key: key);

  @override
  State createState() => _MyConversationsState();
}

class _MyConversationsState extends State<MyConversations> {
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
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, color: Colors.black),
        ),
        backgroundColor: AppColors.solfColor,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppColors.solfColor,
      body: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              color: AppColors.solfColor,
              child: ListTile(
                title: Text(widget.chats[index],
                    style: const TextStyle(color: Colors.black)),
                leading: const Icon(
                  Icons.chat_bubble,
                  color: Colors.black,
                ),
                onTap: () {
                  PdfConversationExport.getPath(widget.chats[index]);
                },
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: widget.chats.length),
      //  bottomNavigationBar:BoxAd(),
    );
  }
}

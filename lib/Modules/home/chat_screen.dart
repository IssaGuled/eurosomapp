import 'dart:io';
import 'package:chat_gpt/API/api.dart';
import 'package:chat_gpt/API/export_conversation.dart';
import 'package:chat_gpt/API/image.dart';
import 'package:chat_gpt/Modules/home/settings_bottomsheet.dart';
import 'package:chat_gpt/Modules/home/widgets/voice_search_component.dart';
import 'package:chat_gpt/Modules/image_gen/img_gen.dart';
import 'package:chat_gpt/Modules/my%20conversation/my_con.dart';
import 'package:chat_gpt/Modules/prompts/prompt.dart';
import 'package:chat_gpt/Modules/subscription/apple_subscription_page.dart';
import 'package:chat_gpt/Modules/subscription/whatsapp_subscription_dialog.dart';
import 'package:chat_gpt/auth/loginPage.dart';
import 'package:chat_gpt/authbackend/user_model.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:chat_gpt/resources/style.dart';
import 'package:chat_gpt/utils/drawer_item.dart';
import 'package:chat_gpt/chat/chat.dart';
import 'package:chat_gpt/chat/bubble.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/robot_icons.dart';
import '../../subscription_page.dart';
import '../../resources/images.dart';
import '../../utils/components.dart';
import '../subscription/subs.dart';
import 'package:badges/badges.dart' as badges;

import 'Home_intro.dart';

class ChatScreen extends StatefulWidget {
  String? prompt;
  String? act;
  String? fieldtext;
  BoxDecoration? decoration;
  Color? color;

  ChatScreen({this.prompt, this.act, this.fieldtext, this.color, this.decoration});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // static final AdRequest request = AdRequest(
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );

  // InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  UserModel userModel = UserModel();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FlutterTts flutterTts = FlutterTts();
  SpeechToText speech = SpeechToText();

  getProfile() async {
    print('${auth.currentUser!.uid}');
    await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      userModel.username = value.data()!['username'];
      userModel.useremail = value.data()!['useremail'];
      userModel.purchased = value.data()!['purchased'];
      // userModel.messages = value.data()!["messages"].toString();
      userModel.tokens = value.data()!["tokens"].toString();
      //userModel.remin = value.data()!['remain'];
      // userModel.profileUrl = value.data()!['profileUrl'];
      // update();
      // print(userModel.messages);
      setState(() {});
      // print(userModel.useremail = value.data()!['useremail']);
    });
  }

  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: notFoundIds.isEmpty
  //           ? Platform.isAndroid
  //               ? 'ca-app-pub-7329154532259868/9486268279'
  //               : "ca-app-pub-7329154532259868/9486268279"
  //           : "",
  //       request: request,
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (InterstitialAd ad) {
  //           print('$ad loaded');
  //           _interstitialAd = ad;
  //           _numInterstitialLoadAttempts = 0;
  //           _interstitialAd!.setImmersiveMode(true);
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('InterstitialAd failed to load: $error.');
  //           _numInterstitialLoadAttempts += 1;
  //           _interstitialAd = null;
  //           if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
  //             _createInterstitialAd();
  //           }
  //         },
  //       ));
  // }

  // _showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //   );
  //   _interstitialAd!.show();
  //   _interstitialAd = null;
  // }

  final TextEditingController _controller = TextEditingController();
  late final ScrollController _scrollController;
  final GlobalKey<FormState> _form = GlobalKey();
  final OpenAiAPI openAiAPI = OpenAiAPI();

  List<ChatInput> chat = [];
  final ImageAPI _imageAPI = ImageAPI();
  List<bool> animated = [];
  bool isEnabled = true;
  Map<int, String> chatText = {};
  int tempIndex = 0;
  int myconversation = 0;
  int saveconverstion = 0;
  int clearconversation = 0;
  int Awesomeprompt = 0;
  int chatIndex = 0;
  int setting = 0;
  int awesomeprompt = 0;
  int imagegeneration = 0;
  int subscription = 0;
  String fileName = '';
  String allPrompt = '';
  bool _canVibrate = true;
  List<String> chats = [];
  bool status3 = false;

  final DateFormat dateFormat = DateFormat("yyyy-mm-dd");
  int reminatodatindex = 0;

  // CacheHelper.getData(key: CacheKeys.remainquestion) ?? 3000;
  int todayQuestionIndex = CacheHelper.getData(key: CacheKeys.numberOfQestions) ?? 0;
  bool isVoiceEnabled = false;

  @override
  void initState() {
    getProfile();

    // _createInterstitialAd();
    // print(notFoundIds.isEmpty ? "usama" : "Found");
    setState(() {});
    getchats();
    _scrollController = ScrollController();
    // IntetialAds();
    setting++;
    super.initState();
    initSpeechState();
  }

  void getchats() async {
    chats = await CacheHelper.getStrings('names') ?? [];
    final today = int.parse(dateFormat.format(DateTime.now()).split("-").join());
    CacheHelper.saveData(key: CacheKeys.todaysDate, value: today);
  }

  @override
  Widget build(BuildContext context) {
    reminatodatindex;
    todayQuestionIndex;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        getchats();
      });
      if (tempIndex == 0) {
        // QestionAd.loadSaveAd();
        // _showInterstitialAd();
        log("Done");
        tempIndex++;
      }
    });
    return Scaffold(
      backgroundColor: AppColors.solfColor,
      appBar: AppBar(
        backgroundColor: widget.color,
        // title: const BoxAd(),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
                onTap: () async {
                  setting++;
                  if (setting % 3 == 0) {
                    // _showInterstitialAd();
                  } else {}
                  settingsBottomSheet();
                  print("object");
                  // QestionAd.loadSaveAd();
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                )),
          )
        ],
        title: InkWell(
          onTap: () {
            // QestionAd.loadSaveAd();
            showOutOfTokenDialog();
            // showalertbox();
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: AppColors.solfColor, border: Border.all(width: 0.2, color: AppColors.hardColor)),
            // width: MediaQuery.of(context).size.width ,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Remaining Tokens",
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
                ),
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(shape: badges.BadgeShape.circle, badgeColor: Colors.white, elevation: 10),
                  onTap: () {
                    // showalertbox();
                  },
                  badgeAnimation: badges.BadgeAnimation.rotation(
                      colorChangeAnimationCurve: Curves.easeInBack,
                      animationDuration: Duration(seconds: 1),
                      colorChangeAnimationDuration: Duration(seconds: 1),
                      disappearanceFadeAnimationDuration: Duration(seconds: 1),
                      curve: Curves.decelerate,
                      loopAnimation: true,
                      toAnimate: true),
                  badgeContent: Text("${userModel.tokens}"),
                  child: Image.asset(
                    "assets/images/prize.png",
                    height: 25,
                    filterQuality: FilterQuality.high,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        // elevation: 10,
      ),
      bottomSheet: VoiceSearchComponent().visible(speech.isListening),
      body: DoubleBack(
        message: "Tap again to exit",
        child: SafeArea(
            child: ListView(
          children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left:10,top:10),
            //       child: Row(
            //         mainAxisAlignment:MainAxisAlignment.spaceBetween,
            //         children: [
            //           InkWell(
            //             onTap: () {
            //               settingsbottomSheet();
            //             },
            //             child:Image.asset("assets/images/Vector.png"),
            //           ),
            // Padding(
            //         padding: const EdgeInsets.only(right: 20.0),
            //         child: InkWell(
            //             onTap: () async {
            //               setting++;
            //               if (setting % 3 == 0) {
            //                 _showInterstitialAd();
            //               } else {}
            //               settingsbottomSheet();
            //               print("object");
            //               // QestionAd.loadSaveAd();
            //             },
            //             child: Icon(
            //               Icons.settings,
            //               color: Colors.black,
            //             )),
            //       )
            //         ],
            //       ),
            //     ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9570FF), // Color of the shadow
                        // spreadRadius: 5, // Spread radius of the shadow
                        // blurRadius: 10, // Blur radius of the shadow
                        offset: Offset(0, 3), // Offset of the shadow
                      ),
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 2,
                        color: Color(0xff4EDFFF),
                        offset: Offset(1, -1),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 3,
                      color: Color.fromRGBO(245, 228, 243, 0.34),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 0),
                      Text(
                        "Read Aloud",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        // width: 40,
                        // height: 70,
                        child: FlutterSwitch(
                          height: 50,
                          width: 40,
                          // activeToggleBorder:
                          //     Border.all(width: 1, color: AppColors.cayanColor),
                          // inactiveIcon: Center(
                          //   child: Image.asset(
                          //     "assets/images/toggle.png",
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                          inactiveColor: Colors.red,
                          activeIcon: Image.asset(
                            "assets/images/toggle.png",
                            fit: BoxFit.fill,
                          ),
                          // activeSwitchBorder:
                          //     Border.all(width: 1, color: Colors.grey),
                          // showOnOff: true,
                          activeColor: Color(0xff4EFF95),
                          value: isVoiceEnabled,
                          onToggle: (val) {
                            isVoiceEnabled = val;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    chat.clear();
                  },
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff9570FF), // Color of the shadow
                          // spreadRadius: 5, // Spread radius of the shadow
                          // blurRadius: 10, // Blur radius of the shadow
                          offset: Offset(0, 3), // Offset of the shadow
                        ),
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 2,
                          color: Color(0xff4EDFFF),
                          offset: Offset(1, -1),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(width: 2, color: AppColors.cayanColor),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Center(
                      child: Text(
                        "Clear Conversation",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey),
            SizedBox(height: 16),
            chat.isNotEmpty
                ? Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 120,
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            chatIndex = index;

                            if (index == chat.length) {
                              if (chat.length >= 2) {
                                // _scrollController.jumpTo(
                                //   _scrollController.position.maxScrollExtent,
                                // );
                              }
                              return const SizedBox(
                                height: 15,
                              );
                            }
                            if (!chatText.containsKey(index)) {
                              chatText.addEntries({index: chat[index].text}.entries);

                              // print(chatText);
                            }
                            return InkWell(
                              onLongPress: () {
                                Clipboard.setData(ClipboardData(text: chat[index].text));
                                Fluttertoast.showToast(msg: "Copied");
                              },
                              onTap: () {
                                chat[index].isDone = false;
                              },
                              child: BubbleSpecialThree(
                                text: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat[index].type == ChatType.user ? chat[index].text.trim() : chat[index].text.trim(),
                                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () => botSpeak(text: chat[index].text),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              color: widget.color!.withOpacity(.8),
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.record_voice_over_outlined,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Builder(builder: (context) {
                                          final box = context.findRenderObject() as RenderBox?;
                                          return InkWell(
                                            onTap: () => share(
                                              context,
                                              text: chat[index].text,
                                              box: box,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                color: widget.color!.withOpacity(.8),
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.share,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                                color: chat[index].type == ChatType.user
                                    ? const Color.fromRGBO(235, 109, 238, 0.1)
                                    : const Color.fromRGBO(149, 112, 255, 0.05),
                                tail: true,
                                delivered: true,
                                isTextAnimating: chat[index].type == ChatType.bot && chat[index].isDone,
                                isSender: chat[index].type == ChatType.user ? true : false,
                                seen: true,
                                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: chat.length + 1,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              _scrollController.animateTo(_scrollController.position.maxScrollExtent + 10,
                                  duration: const Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
                            },
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                            )),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // SizedBox(
                        //   height: 40,
                        // ),

                        // Container(
                        //   height: 200,
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //           image: AssetImage("assets/images/logo.png"),
                        //           fit: BoxFit.contain)),
                        // ),
                        const Icon(
                          Icons.thunderstorm,
                          size: 50,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Capabilities",
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   width: 330,
                        //   padding: const EdgeInsets.all(10),
                        //   decoration:widget.decoration,
                        //   child: Text(widget.act.toString(),
                        //       textAlign: TextAlign.center,
                        //       style: GoogleFonts.openSans(
                        //           fontWeight: FontWeight.w600, fontSize: 16)),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 250,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(color: AppColors.hardColor, borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            'Use this app to ask appropriate questions only',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Icon(
                          Icons.wb_sunny_outlined,
                          size: 50,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Examples",
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            _controller.text = 'Explain how quantum computing can help encryption in simple terms';
                          },
                          child: Container(
                            width: 250,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(color: AppColors.hardColor, borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              'Explain how quantum computing can help encryption in simple terms',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            _controller.text =
                                widget.prompt == null ? 'Do you have creative ideas about AI and 6 years old’s birthdays?' : widget.prompt.toString();

                            // widget.prompt!.isEmpty?
                            // _controller.text =
                            //     'Got any creative ideas for a 10 year old’s birthday?':widget.prompt;
                          },
                          child: Container(
                            width: 250,
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(color: AppColors.hardColor, borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              widget.prompt == null ? 'Do you have creative ideas about AI and 6 years old’s birthdays?' : widget.prompt.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Unofficial",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
          ],
        )),
      ),
      bottomNavigationBar: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: widget.color ?? Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color!.withOpacity(.3),
                            blurRadius: 20,
                            spreadRadius: .1,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                enabled: isEnabled,
                                minLines: 1,
                                maxLines: 4,
                                controller: _controller,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: widget.color ?? Colors.black87,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                    color: widget.color?.withOpacity(.4) ?? Colors.black54,
                                    fontSize: 14,
                                  ),
                                  hintText: widget.fieldtext,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  // suffix: Row(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  //     if (isEnabled)
                                  //       InkWell(
                                  //         onTap: () async {
                                  //           final res = await _imageAPI.getImage(ImageSource.gallery);
                                  //           setState(() {
                                  //             _controller.text = res;
                                  //           });
                                  //         },
                                  //         child: const Icon(Icons.camera_alt_outlined, color: Colors.black54),
                                  //       ),
                                  //     const SizedBox(width: 10),
                                  //   ],
                                  // ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => startListening(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.mic,
                                  color: widget.color,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  FloatingActionButton.small(
                    onPressed: isEnabled ? () => send() : null,
                    backgroundColor: widget.color,
                    child: isEnabled
                        ? const Icon(
                            Icons.send,
                            color: Colors.white,
                          )
                        : SpinKitThreeBounce(
                            color: Color(0xffffffff),
                            size: 20,
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 10,
        backgroundColor: widget.color,
        child: DrawerHeader(
          curve: Curves.slowMiddle,
          child: Column(
            children: [
              DrawerItem(
                image: "assets/images/con.png",
                text: "My Chats",
                onPressed: () {
                  C.pop(context);
                  myconversation++;
                  // if (myconversation % 2 == 0) {
                  //   _showInterstitialAd();
                  // }
                  C.navTo(context, MyConversations(chats: chats));
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  DrawerItem(
                    image: "assets/images/savechat.png",
                    text: "Save Chats",
                    onPressed: () async {
                      saveconverstion++;
                      // if (saveconverstion % 2 == 0) {
                      //   _showInterstitialAd();
                      // }
                      var chatPdf = await PdfConversationExport.exportChat(chat);
                      setState(() {
                        log(chatPdf.path);
                      });
                      PdfConversationExport.openPdfFile(chatPdf);
                    },
                  ),
                  // Text(chatPdf.toString())
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              DrawerItem(
                image: "assets/images/clear.png",
                text: "Clear  Current Chat",
                onPressed: () async {
                  clearconversation++;
                  // if (clearconversation % 5 == 0) {
                  //   _showInterstitialAd();
                  // }
                  setState(() {
                    chat.clear();
                    chatText.clear();
                    animated.clear();
                  });
                  if (isVoiceEnabled) {
                    OpenAiAPI.tts("Stopped");
                  }
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),

              // DrawerItem(
              //   image: "assets/images/awesome.png",
              //   text: "Awesome Prompts",
              //   onPressed: () async {
              //     awesomeprompt++;
              //     // if (awesomeprompt % 2 == 0) {
              //     //   _showInterstitialAd();
              //     // }
              //     C.pop(context);
              //     C.navTo(context, const AwsomePrompt());
              //   },
              // ),
              DrawerItem(
                icon: Icons.photo,
                text: "Image Generator",
                onPressed: () async {
                  imagegeneration++;
                  // if (imagegeneration % 5 == 0) {
                  //   _showInterstitialAd();
                  // }
                  C.pop(context);
                  C.navTo(context, const ImgGen());
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              DrawerItem(
                image: "assets/images/sub.png",
                text: "Subscriptions",
                onPressed: () async {
                  subscription++;
                  // if (subscription % 2 == 0) {
                  //   _showInterstitialAd();
                  // }
                  C.pop(context);
                  if (Platform.isAndroid)
                    C.navToDown(context, const SubscriptionPage());
                  else
                    Get.dialog(WhatsAppSubscriptionDialog(user: userModel));
                },
              ),

              DrawerItem(
                icon: Icons.home,
                text: "Back To Home",
                onPressed: () async {
                  setting++;
                  if (setting % 2 == 0) {
                    // _showInterstitialAd();
                  }
                  C.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.star,
              //     color: Colors.white,
              //   ),
              //   title: const Text(
              //     'Rate The app',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onTap: () {
              //     launchUrl(
              //         Uri.parse(
              //             "https://play.google.com/store/apps/details?id=com.amaa.chatgpt"),
              //         mode: LaunchMode.externalApplication);
              //   },
              // ),

              Expanded(child: SizedBox()),
              DrawerItem(
                icon: Icons.settings,
                text: "Settings",
                onPressed: () async {
                  setting++;
                  if (setting % 2 == 0) {
                    // _showInterstitialAd();
                  }
                  C.pop(context);
                  settingsBottomSheet();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void send() async {
    getProfile();
    print(userModel.useremail);
    print(userModel.tokens);
    if (userModel.tokens == '0') {
      if (_canVibrate) {
        Vibrate.feedback(FeedbackType.error);
      }
      showOutOfTokenDialog();
    } else {
      if (_form.currentState!.validate()) {
        allPrompt = "";
        chat.add(ChatInput(
          text: _controller.text,
          type: ChatType.user,
        ));
        chatText.forEach((key, value) {
          allPrompt += "${widget.prompt} \n\n $value";
        });

        setState(() {
          isEnabled = false;
        });
        final String botResponse = await openAiAPI.generateResponse(
          "${allPrompt.replaceAll("null", "").replaceAll("Null", "")} \n\n ${_controller.text}",
        );

        if (isVoiceEnabled) {
          OpenAiAPI.tts(botResponse);
        }
        chat.add(ChatInput(text: botResponse, type: ChatType.bot, isDone: true));
        setState(() {
          isEnabled = true;
        });

        _controller.clear();
        if (openAiAPI.totalTokens > 150) {
          // _showInterstitialAd();
          tempIndex = 0;
        }
        setState(() {
          if (chat.length > 2) {
            if (chat[chatIndex].type == ChatType.bot) {
              chat[chatIndex - 2].isDone = false;
            }
          }
        });

        todayQuestionIndex++;
        // if (todayQuestionIndex % 8 == 0) {
        //   _showInterstitialAd();
        // }
        reminatodatindex--;
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'tokens': '${int.parse(userModel.tokens!) - 1}'.toString()}).then((value) {
          getProfile();
        });
        print("messages");
        // CacheHelper.saveData(
        //     key: CacheKeys.numberOfQestions, value: todayQuestionIndex);
        // CacheHelper.saveData(
        //     key: CacheKeys.remainquestion, value: reminatodatindex);
      }
    }
  }

  void showOutOfTokenDialog() {
    if (Platform.isIOS) {
      Get.dialog(WhatsAppSubscriptionDialog(user: userModel));
      return;
    } else {
      Get.to(SubscriptionPage());
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  // QestionAd.loadSaveAd();
                  Get.back();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
              )
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.cayanColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Alert",
                style: GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Are you running out of the token? ",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.solfColor,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: <Widget>[
            InkWell(
                onTap: () async {
                  Get.to(SubscriptionPage());
                  // final url = Uri(
                  //   scheme: 'mailto',
                  //   path: 'info@eurosom.com',
                  //   query: 'subject=Token Expiration&body=I running out of the tokens.,\n\n', //add subject and body here
                  // );
                  // if (!await launchUrl(url)) {
                  //   throw Exception('Could not launch $url');
                  // }
                },
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      color: AppColors.hardColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.hardColor,
                          // blurRadius: 15.0, // soften the shadow
                          spreadRadius: 4.0, //extend the shadow
                          offset: Offset(
                            0.0,
                            2.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                      gradient: LinearGradient(colors: [
                        AppColors.solfColor,
                        AppColors.solfColor,
                      ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Get Unlimited Chat",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black, fontStyle: FontStyle.italic),
                      ),
                    ))),
            SizedBox(
              height: 40,
            ),
            // InkWell(
            //     onTap: () async {
            //       // _showInterstitialAd();
            //
            //       todayQuestionIndex = 0;
            //       reminatodatindex = 5;
            //       CacheHelper.saveData(
            //           key: CacheKeys.numberOfQestions, value: 0);
            //       CacheHelper.saveData(key: CacheKeys.remainquestion, value: 5);
            //       Get.back();
            //     },
            //     child: Container(
            //         height: 50,
            //         width: MediaQuery.of(context).size.width / 1.150,
            //         decoration: BoxDecoration(
            //           color: AppColors.hardColor,
            //           boxShadow: [
            //             BoxShadow(
            //               color: AppColors.hardColor,
            //               // blurRadius: 15.0, // soften the shadow
            //               spreadRadius: 4.0, //extend the shadow
            //               offset: Offset(
            //                 0.0,
            //                 2.0, // Move to bottom 5 Vertically
            //               ),
            //             )
            //           ],
            //           gradient: LinearGradient(colors: [
            //             AppColors.solfColor,
            //             AppColors.solfColor,
            //           ]),
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Center(
            //           child: Text(
            //             "Watch Ads",
            //             style: GoogleFonts.poppins(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.black),
            //           ),
            //         ))),
            // SizedBox(
            //   height: 40,
            // ),
          ],
        );
      },
    );
  }

  settingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.hardColor,
      isScrollControlled: true,
      builder: (context) => SettingsBottomSheet(
        isVoiceEnabled: isVoiceEnabled,
        onClear: () {
          chat.clear();
          allPrompt = '';
          chats.clear();
          chatText.clear();
          animated.clear();
        },
        onToggle: (value) {
          isVoiceEnabled = value;
        },
      ),
    );
  }

  void share(BuildContext context, {String? text, RenderBox? box}) async {
    await Share.share(
      'Eurosom AI: $text',
      sharePositionOrigin: Platform.isIOS ? box!.localToGlobal(Offset.zero) & box.size : null,
    );
  }

  void botSpeak({required String text}) async {
    await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5); //speed of speech
    await flutterTts.setVolume(1.0); //volume of speech
    await flutterTts.setPitch(1); //pitch of sound

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  Future<void> initSpeechState() async {
    print("======== INITIALIZING STT =========");
    final available = await speech.initialize(onError: errorListener, onStatus: statusListener);
    print("======== STT ::: $available");
  }

  Future<void> startListening() async {
    final isGranted = Platform.isAndroid ? await Permission.microphone.isGranted : true;
    if (isGranted) {
      // lastError = "";
      // print("======== START LISTENING =========");
      speech.listen(onResult: resultListener, pauseFor: Duration(seconds: 4));

      setState(() {});
    } else {
      final allowed = await Permission.microphone.request().isGranted;
      if (allowed) {
        await initSpeechState();
        startListening();
      }
    }
  }

  void stopListening() {
    print("======== STOP LISTENING =========");
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    log('Speech result=== $result');
    log('Speech result=== ${result.recognizedWords.capitalizeFirstLetter()}');
    _controller.text = "${result.recognizedWords.capitalizeFirstLetter()} ?";
    setState(() {});
  }

  void errorListener(SpeechRecognitionError error) {
    // setState(() {
    //   lastError = "${error.errorMsg} - ${error.permanent}";
    // });
    print("======== STT ERROR :: ${error.errorMsg} - ${error.permanent} =========");
  }

  void statusListener(String status) {
    print("======== STT STATUS $status =========");
    setState(() {});
    // setState(() {
    // lastStatus = "$status";
    // });
  }
}

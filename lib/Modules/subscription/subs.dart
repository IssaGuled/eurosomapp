// import 'package:chat_gpt/ads/banner.dart';
// import 'package:chat_gpt/resources/colors.dart';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'package:pay/pay.dart';
// import 'package:tab_indicator_styler/tab_indicator_styler.dart';
//
// import '../../utils/button.dart';
// import '../../utils/components.dart';
// import '../home/chat_screen.dart';
//
// class Subscription extends StatefulWidget {
//   final int intialIndex;
//   const Subscription({Key? key, this.intialIndex = 1}) : super(key: key);
//
//   @override
//   State createState() => _SubscriptionState();
// }
//
// class _SubscriptionState extends State<Subscription>
//     with SingleTickerProviderStateMixin {
//   final _paymentItemsPro = [
//     const PaymentItem(
//       label: 'Total',
//       amount: '99.99',
//       status: PaymentItemStatus.final_price,
//     )
//   ];
//   final _paymentItemsAdvanced = [
//     const PaymentItem(
//       label: 'Total',
//       amount: '109.99',
//       status: PaymentItemStatus.final_price,
//     )
//   ];
//   late final TabController _tabController;
//   int currentProIndex = 0;
//   int currentAdvancedIndex = 0;
//   late final Future<PaymentConfiguration> _googlePayConfigFuture;
//   final priceListPro = ["\$4.99/week", "\$19.99/month"];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController =
//         TabController(length: 2, vsync: this, initialIndex: widget.intialIndex);
//     _googlePayConfigFuture = PaymentConfiguration.fromAsset('g_pay.json');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: AppColors.solfColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.solfColor,
//           elevation: 0,
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   C.navToRemoveDown(context,  Home());
//                 },
//                 child: const Text("Skip"))
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       color: AppColors.hardColor,
//                       borderRadius: BorderRadius.circular(50)),
//                   child: TabBar(
//                       controller: _tabController,
//                       labelColor: Colors.black,
//                       labelStyle:GoogleFonts.poppins(fontWeight:FontWeight.w500,fontSize:16,color:Colors.black),
//                       enableFeedback: true,
//                       tabs: const [
//                         Tab(
//                           text: "Lite",
//                         ),
//                         Tab(
//                           text: "Pro",
//                         ),
//                         // Tab(
//                         //   text: "Advanced",
//                         // ),
//                       ],
//                       indicator: RectangularIndicator(
//                           topLeftRadius: 50,
//                           bottomRightRadius: 50,
//                           bottomLeftRadius: 50,
//                           topRightRadius: 50,
//                           color: AppColors.cayanColor.withOpacity(0.8))),
//                 ),
//                 SizedBox(
//                   height: 580,
//                   child: TabBarView(controller: _tabController, children: [
//                     _subscriptionBuilder(0),
//                     _subscriptionBuilder(1),
//                   ]),
//                 ),
//                Container(
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(22),
//                      color:AppColors.solfColor,
//                      gradient: LinearGradient(colors: AppColors.gradiantColors)),
//                  child: FutureBuilder<PaymentConfiguration>(
//                      future: _googlePayConfigFuture,
//                      builder: (context, snapshot) => snapshot.hasData
//                          ? GooglePayButton(
//                        width: double.infinity,
//                        paymentConfiguration: snapshot.data!,
//                        paymentItems: _tabController.index == 1
//                            ? _paymentItemsPro
//                            : _paymentItemsAdvanced,
//                        type: GooglePayButtonType.pay,
//                        margin: EdgeInsets.only(top: 8.0),
//                        onPaymentResult: onGooglePayResult,
//                        loadingIndicator: const Center(
//                          child: CircularProgressIndicator(),
//                        ),
//                      )
//                          : const SizedBox.shrink()),
//
//                ),
//                 SizedBox(height:20,),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar:BoxAd(),
//       ),
//     );
//   }
//
//   void onGooglePayResult(paymentResult) async {}
//
//   _subscriptionBuilder(int index) => Padding(
//         padding: const EdgeInsets.only(top: 25.0, left: 18, right: 18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               index == 0 ? "Continue Free" : "Let the genie out of the bottle!",
//               style: const TextStyle(fontSize: 26, color: Colors.white),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//              Text(
//               "Get access to",
//               style:GoogleFonts.poppins(fontWeight:FontWeight.w500,color:Colors.black),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: AppColors.hardColor),
//                 child: Column(
//                   children: <Widget>[
//                     _featuresItem(
//                         Icons.check_circle_outline,
//                         index == 0
//                             ? "5 Questions a day"
//                             : "Unlimited Questions & Answers"),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     if (index != 0)
//                       _featuresItem(Icons.check_circle_outline,
//                           "Unlimited Image Generation"),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     _featuresItem(Icons.check_circle_outline,
//                         "Most Advanced GPT-3 Model (Davinci)"),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     _featuresItem(
//                         Icons.check_circle_outline,
//                         index == 0
//                             ? "Very limited Word Response"
//                             : index == 1
//                                 ? "Higher Word Limit"
//                                 : "Full response"),
//
//                     // if (index != 0)
//                     //   _featuresItem(
//                     //       Icons.check_circle_outline, "Awesome Prompts"),
//                     // const SizedBox(
//                     //   height: 15,
//                     // ),
//                     // if (index == 2)
//                     //   _featuresItem(Icons.check_circle_outline, "AI Rewirter"),
//                     // if (index == 2)
//                     //   const SizedBox(
//                     //     height: 15,
//                     //   ),
//                     // if (index == 2)
//                     //   _featuresItem(
//                     //       Icons.check_circle_outline, "Plagiarism Checker"),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height:50,),
//             // const Spacer(),
//             if (index == 1)
//               ListView.separated(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           currentProIndex = index;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(18),
//                         decoration: BoxDecoration(
//                             color: currentProIndex == index
//                                 ?AppColors.cayanColor
//                                 : AppColors.hardColor,
//                             borderRadius: BorderRadius.circular(22)),
//                         child: Text(
//                           priceListPro[index],
//                           style:GoogleFonts.poppins(fontWeight:FontWeight.w500,color:Colors.black,fontSize:16),
//                         ),
//                       ),
//                     );
//                   },
//                   separatorBuilder: (context, index) => const SizedBox(
//                         height: 15,
//                       ),
//                   itemCount: 2),
//
//           ],
//         ),
//       );
//   _featuresItem(IconData icon, String text) => Row(
//         children: <Widget>[
//           Icon(icon),
//           const SizedBox(
//             width: 8,
//           ),
//           Text(text,style:GoogleFonts.poppins(fontWeight:FontWeight.w300,fontSize:12,color:Colors.black),),
//           SizedBox(height:10,),
//
//         ],
//       );
//
// }

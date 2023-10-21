import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:chat_gpt/Modules/home/Home_intro.dart';
import 'package:chat_gpt/authbackend/user_model.dart';
import 'package:chat_gpt/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:merchant_evc_plus/merchant_evc_plus.dart';
import 'package:just_bottom_sheet/drag_zone_position.dart';
import 'package:just_bottom_sheet/just_bottom_sheet.dart';
import 'package:just_bottom_sheet/just_bottom_sheet_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:clipboard/clipboard.dart';

import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatefulWidget {
  final int intialIndex;

  const SubscriptionPage({Key? key, this.intialIndex = 1}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with SingleTickerProviderStateMixin {
  UserModel userModel = UserModel();
  late final TabController _tabController;
  int priceindex = 0;
  int payindex = 0;
  int currentAdvancedIndex = 0;
  int? invoiceId = 0;
  final invoiceContrroller = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  getProfile() async {
    await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      userModel.username = value.data()!['username'];
      userModel.useremail = value.data()!['useremail'];
      userModel.purchased = value.data()!['purchased'];
      // userModel.profileUrl = value.data()!['profileUrl'];
      // update();
      print(userModel.useremail = value.data()!['useremail']);
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.intialIndex);

    // TODO: implement initState
    super.initState();
  }

  final scrollController = ScrollController();

  String? phone;
  String? edphone2;
  num? amount;
  String? edhstatus = '';
  var price = ["\$1.00 monthly ", "  \$12.00 yearly"];
  var name = [
    'Credit Card',
    'EVC Plus',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.solfColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text('Subscription'),
          //  backgroundColor: AppColors.solfColor,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.hardColor, borderRadius: BorderRadius.circular(50)),
                  child: _subscriptionBuilder(1),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BoxAd()
      ),
    );
  }

  _subscriptionBuilder(int index) => Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text(
                "Get access to Monthly",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: AppColors.hardColor),
                  child: Column(
                    children: <Widget>[
                      _featuresItem(Icons.check_circle_outline, "Monthly 3000 Tokens"),
                      const SizedBox(
                        height: 15,
                      ),
                      if (index != 0)
                        _featuresItem(Icons.check_circle_outline, "Unlimited Image Generation"),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 100),
                        child: Text(
                          "Get access to 12 Month",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _featuresItem(Icons.check_circle_outline, "Monthly 7000 Tokens"),
                      const SizedBox(
                        height: 15,
                      ),
                      if (index != 0)
                        _featuresItem(Icons.check_circle_outline, "Unlimited Image Generation"),
                      const SizedBox(
                        height: 15,
                      ),
                      _featuresItem(
                          Icons.check_circle_outline, "Most Advanced GPT-4 Model (Davinci)"),
                      const SizedBox(
                        height: 15,
                      ),
                      _featuresItem(
                          Icons.check_circle_outline,
                          index == 0
                              ? "Very limited Word Response"
                              : index == 1
                                  ? "Higher Word Limit"
                                  : "Full response"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0,
              ),
              // const Spacer(),
              if (index == 1)
                Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              priceindex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color:
                                  priceindex == index ? AppColors.cayanColor : AppColors.hardColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                price[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemCount: price.length,
                    ),
                    SizedBox(height: 0),
                    InkWell(
                      onTap: () {
                        if (priceindex == 0) {
                          makePayment('2');
                        } else {
                          makePayment('24');
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: AppColors.hardColor, borderRadius: BorderRadius.circular(22)),
                          child: Text(
                            name[0],
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                          )),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        showJustBottomSheet(
                          context: context,
                          dragZoneConfiguration: JustBottomSheetDragZoneConfiguration(
                            dragZonePosition: DragZonePosition.outside,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 4,
                                width: 30,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.white,
                              ),
                            ),
                          ),
                          configuration: JustBottomSheetPageConfiguration(
                            height: MediaQuery.of(context).size.height,
                            builder: (context) {
                              return Scaffold(
                                body: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(height: 30),
                                    Container(
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                            color: AppColors.hardColor,
                                            borderRadius: BorderRadius.circular(22)),
                                        child: Text(
                                          'EVC Plus',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        )),
                                    const SizedBox(height: 30),
                                    Container(
                                      margin: EdgeInsets.only(left: 30, right: 30),
                                      child: Row(
                                        children: [
                                          Text("+251"),
                                          TextField(
                                            // validator: (value) {
                                            //   if (value != null) if (value.isEmpty)
                                            //     return 'Phone No';
                                            // },
                                            onChanged: (newValue) {
                                              if (newValue != null) phone = newValue;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Phone No',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    ElevatedButton(
                                      child: Text('Pay ${priceindex == 0 ? '\$1' : '\$12'}'),
                                      onPressed: () {
                                        if (priceindex == 0) {
                                          makePaymentEVC(1);
                                        } else {
                                          makePaymentEVC(12);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            scrollController: scrollController,
                            closeOnScroll: true,
                            cornerRadius: 16,
                            backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
                            backgroundImageFilter: ImageFilter.blur(
                              sigmaX: 30,
                              sigmaY: 30,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: AppColors.hardColor, borderRadius: BorderRadius.circular(22)),
                          child: Text(
                            name[1],
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                          )),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        showJustBottomSheet(
                          context: context,
                          dragZoneConfiguration: JustBottomSheetDragZoneConfiguration(
                            dragZonePosition: DragZonePosition.outside,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 4,
                                width: 30,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.white,
                              ),
                            ),
                          ),
                          configuration: JustBottomSheetPageConfiguration(
                            height: MediaQuery.of(context).size.height,
                            builder: (context) {
                              return Scaffold(
                                body: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(height: 30),
                                    Container(
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                            color: AppColors.hardColor,
                                            borderRadius: BorderRadius.circular(22)),
                                        child: Text(
                                          'eDahab',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        )),
                                    const SizedBox(height: 30),
                                    Container(
                                      margin: EdgeInsets.only(left: 30, right: 30),
                                      child: TextField(
                                        // validator: (value) {
                                        //   if (value != null) if (value.isEmpty)
                                        //     return 'Phone No';
                                        // },
                                        onChanged: (newValue) {
                                          if (newValue != null) edphone2 = newValue;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Phone No',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                      child:
                                          Text('eDahab ${priceindex == 0 ? '\$1.00' : '\$12.00'}'),
                                      onPressed: () {
                                        if (priceindex == 0) {
                                          edhadPay('1');
                                        } else {
                                          edhadPay('12');
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    Container(
                                      margin: EdgeInsets.only(left: 30, right: 30),
                                      child: TextField(
                                        controller: invoiceContrroller,
                                        // validator: (value) {
                                        //   if (value != null) if (value.isEmpty)
                                        //     return 'Phone No';
                                        // },
                                        onChanged: (newValue) {
                                          if (newValue != null) invoiceId = int.parse(newValue);
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'InvoiceID',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      child: Text('Verfiy the payment'),
                                      onPressed: () {
                                        if (invoiceId != 0) {
                                          verifyedahahPay(invoiceId!, priceindex == 0 ? '1' : '12');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            scrollController: scrollController,
                            closeOnScroll: true,
                            cornerRadius: 16,
                            backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
                            backgroundImageFilter: ImageFilter.blur(
                              sigmaX: 30,
                              sigmaY: 30,
                            ),
                          ),
                        );
                        //edhadPay('1', 'USD');
                      },
                      child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: AppColors.hardColor, borderRadius: BorderRadius.circular(22)),
                          child: Text(
                            'eDahab',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                          )),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        showJustBottomSheet(
                          context: context,
                          dragZoneConfiguration: JustBottomSheetDragZoneConfiguration(
                            dragZonePosition: DragZonePosition.outside,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 4,
                                width: 30,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.white,
                              ),
                            ),
                          ),
                          configuration: JustBottomSheetPageConfiguration(
                            height: MediaQuery.of(context).size.height,
                            builder: (context) {
                              return Scaffold(
                                body: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(height: 30),
                                    Container(
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                            color: AppColors.hardColor,
                                            borderRadius: BorderRadius.circular(22)),
                                        child: Text(
                                          'eWallet',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        )),
                                    // const SizedBox(height: 30),
                                    // Center(
                                    //   child: Container(
                                    //       margin: const EdgeInsets.only(
                                    //           left: 70, right: 30),
                                    //       child: Row(
                                    //         children: [
                                    //           Text(
                                    //             'Phone No:',
                                    //             style: GoogleFonts.poppins(
                                    //                 fontSize: 14,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Colors.black),
                                    //           ),
                                    //           const Text('  0619255803'),
                                    //           IconButton(
                                    //               onPressed: () {
                                    //                 FlutterClipboard.copy(
                                    //                         '0619255803')
                                    //                     .then((value) =>
                                    //                         print('copied'));
                                    //               },
                                    //               icon: const Icon(
                                    //                   Icons.copy_all))
                                    //         ],
                                    //       )),
                                    // ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                          margin: const EdgeInsets.only(left: 70, right: 30),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Cashier Id:',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              const Text('  0 6 8 4 0 0'),
                                              IconButton(
                                                  onPressed: () {
                                                    FlutterClipboard.copy('0 6 8 4 0 0')
                                                        .then((value) => print('copied'));
                                                  },
                                                  icon: const Icon(Icons.copy_all))
                                            ],
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                      child:
                                          Text('eWallet ${priceindex == 0 ? '\$1.00' : '\$12.00'}'),
                                      onPressed: () {
                                        // if (priceindex == 0) {
                                        //   edhadPay('1');
                                        // } else {
                                        //   edhadPay('12');
                                        // }
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    Container(
                                      margin: EdgeInsets.only(left: 30, right: 30),
                                      child: TextField(
                                        controller: invoiceContrroller,
                                        // validator: (value) {
                                        //   if (value != null) if (value.isEmpty)
                                        //     return 'Phone No';
                                        // },
                                        onChanged: (newValue) {
                                          if (newValue != null) invoiceId = int.parse(newValue);
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Transition ID',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      child: Text('Verfiy the payment'),
                                      onPressed: () {
                                        makePostRequest();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            scrollController: scrollController,
                            closeOnScroll: true,
                            cornerRadius: 16,
                            backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
                            backgroundImageFilter: ImageFilter.blur(
                              sigmaX: 30,
                              sigmaY: 30,
                            ),
                          ),
                        );
                        //edhadPay('1', 'USD');
                      },
                      child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: AppColors.hardColor, borderRadius: BorderRadius.circular(22)),
                          child: Text(
                            'eWallet',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                          )),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );

  _featuresItem(IconData icon, String text) => Row(
        children: <Widget>[
          Icon(icon),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 10, color: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );

  void makePaymentEVC(int amount) async {
    makeEVCPaymentApiCall(
      apiKey: 'API-1685988125AHX',
      merchantUid: 'M0912379',
      apiUserId: '1005011',
      payerPhoneNumber: phone?.trim() ?? '',
      amount: amount.toDouble(),
      invoiceId: 'INV-PLAN-Test1',
      onSuccess: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment Successful'),
        ));
        if (amount == 12) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '7000',
            "package": amount,
            'days': "year ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": false,
          });
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '3000',
            "package": amount,
            'days': "month ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": true,
          });
        }
        Get.to(() => Homepage());
      },
      onFailure: (error) {
        print("EVC:: FAILED:: ${error.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment Failed Try Again'),
        ));
      },
    );
    //  setState(() => isLoading = !isLoading);
  }

  Future<void> makeEVCPaymentApiCall(
      {required String apiKey,
      required String merchantUid,
      required String apiUserId,
      required String payerPhoneNumber,
      required double amount,
      required String invoiceId,
      required Function() onSuccess,
      required Function(dynamic error) onFailure}) async {
    try {
      print("REQUEST:: ${amount.toString()}");
      http.Response response = await http.post(
        Uri.parse("https://api.waafipay.net/asm"),
        body: json.encode(
          {
            "schemaVersion": "1.0",
            "requestId": "6340305271",
            "timestamp": "client_timestamp",
            "channelName": "WEB",
            "serviceName": "API_PURCHASE",
            "serviceParams": {
              "merchantUid": merchantUid,
              "apiUserId": apiUserId,
              "apiKey": apiKey,
              "paymentMethod": "MWALLET_ACCOUNT",
              "payerInfo": {"accountNo": "252$payerPhoneNumber"},
              "transactionInfo": {
                "referenceId": '${DateTime.now().millisecond}',
                "invoiceId": '${DateTime.now().millisecond}',
                "amount": amount.toString(),
                "currency": "USD",
                "description": "Test",
                "paymentBrand": "WAAFI",
                "transactionCategory": "ECOMMERCE"
              }
            }
          },
        ),
      );
      print("RESPONSE:: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["responseMsg"] == 'RCS_SUCCESS') {
          onSuccess();
          return;
        }
        String message = '';
        var errMessage = data['responseMsg'].toString().split(':');
        if (errMessage.length < 2) {
          message = 'RCS_USER_IS_NOT_AUTHZ_TO_ACCESS_API';
        } else if (errMessage[2] == ' User Aborted)') {
          message = 'User Cancelled';
        } else if (errMessage[2] == ' Subscriber Not Found)') {
          message = 'Wrong Telephone Number';
        } else if (errMessage[2] == ' Invalid PIN)') {
          message = 'Invalid PIN';
        } else if (errMessage[2] == ' Customer rejected to authorize payment)') {
          message = 'User Rejected';
        } else if (errMessage[2] == ' Dialog Timedout)') {
          message = 'Dialog Timedout';
        } else if (errMessage[2].contains('Timeout')) {
          message = 'User Timeout';
        } else {
          message = response.body.toString();
        }
        onFailure(message);
      } else {
        onFailure(response.body);
      }
    } on SocketException {
      onFailure('No Internet Connection');
    } catch (e) {
      print(e);
      onFailure(e.toString());
    }
  }

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(String s) async {
    try {
      paymentIntent = await createPaymentIntent('$s', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan',
            ),
          )
          .then(
            (value) {},
          );

      ///now finally display payment sheeet
      displayPaymentSheet(s);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String s) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        // context.read<EurosomBloc>().add(EurosomEvent.createSubscription(
        //     'Stripe', price!.price!, price!, widget.appId));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        if (s == '24') {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '7000',
            "package": s,
            'days': "year ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": false,
          });
        } else {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '3000',
            "package": s,
            'days': "month ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": true,
          });
        }
        Get.to(() => Homepage());
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  edhadPay(String amount1) async {
    final Map<String, dynamic> requestParam = {
      "apiKey": "jYOwFlRjcJ8Qe1F5QHzOzFff8i8kff2IKZxo78pew",
      "edahabNumber": edphone2?.trim() ?? '',
      "amount": amount1,
      "agentCode": "091616",
      "returnUrl": "https://eurosom.com/"
    };

    final String json = jsonEncode(requestParam);
    final String hashed =
        sha256.convert(utf8.encode(json + "Kb7uoU8RfwHl10WNec9ZEjfxIrKsQJdZsoTlG5")).toString();

    final String url = "https://edahab.net/api/api/IssueInvoice?hash=$hashed";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json,
    );

    if (response.statusCode == 200) {
      final String result = response.body;
      // Get the InvoiceId from the API response and store it in your database.
      print(result);
      Map<String, dynamic> map = jsonDecode(result);
      setState(() {
        invoiceContrroller.text = map['InvoiceId'].toString();
        invoiceId = map['InvoiceId'];
      });
      _launchUrl(invoiceId.toString(), amount1);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> verifyedahahPay(int invice, String s) async {
    final Map<String, dynamic> requestParam = {
      "apiKey": "jYOwFlRjcJ8Qe1F5QHzOzFff8i8kff2IKZxo78pew",
      "invoiceId": invice,
    };

    final String json = jsonEncode(requestParam);
    final String hashed =
        sha256.convert(utf8.encode(json + "Kb7uoU8RfwHl10WNec9ZEjfxIrKsQJdZsoTlG5")).toString();

    final String url = "https://edahab.net/api/api/CheckInvoiceStatus?hash=$hashed";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json,
    );

    if (response.statusCode == 200) {
      final String result = response.body;
      Map<String, dynamic> map = jsonDecode(result);
      setState(() {
        edhstatus = map['InvoiceStatus'];
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment Status :$edhstatus'),
      ));
      if (map['InvoiceStatus'] == 'Paid') {
        if (s == "12") {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '7000',
            "package": s,
            'days': "year ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": false,
          });
        } else {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '3000',
            "package": s,
            'days': "month ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": true,
          });
        }
        Get.to(() => Homepage());
      }
      print(result);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _launchUrl(String inviceID, String amount1) async {
    final Uri _url = Uri.parse('https://edahab.net/api/payment?invoiceId=$inviceID');

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future<void> makePostRequest() async {
    final url =
        'https://api.premierwallets.com/api/MerchantLogin'; // Replace with your API endpoint

    final username = 'IBMZ4P';
    final password = 'DQ36WT';
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var headers = {
      'Authorization': basicAuth,
      'ChannelID': '104',
      'DeviceType': '205',
      'MachineID': 'ds@#13ds!WE4C#FW\$672@',
      'Content-Type': 'application/json', // Set the appropriate content-type for your request
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Request successful!');
      Map<String, dynamic> map = jsonDecode(response.body);
      String token = map['Data']['Token'];
      print('token here $token');
      makePostRequestVerify(token, map['Data']['Amount']);
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> makePostRequestVerify(String? token, amount1) async {
    final url =
        'https://api.premierwallets.com/api/GetPaymentDetails'; // Replace with your API endpoint

    final username = 'IBMZ4P';
    final password = 'DQ36WT';
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final body = {"TransactionID": invoiceContrroller.text, "LoginUserName": "068400"};
    var headers = {
      'Authorization': 'Bearer $token',
      'ChannelID': '104',
      'DeviceType': '205',
      'MachineID': 'ds@#13ds!WE4C#FW\$672@',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Request successful!');
      Map<String, dynamic> map = jsonDecode(response.body);
      // String token = map['Status'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Payment Status :${map['Status'] == null ? 'Invalid Transition ID' : map['Status']}'),
      ));
      if (map['InvoiceStatus'] == 'Executed') {
        if (amount1 == 12) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '7000',
            "package": amount1,
            'days': "year ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": false,
          });
        } else {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "purchased": true,
            "tokens": '3000',
            "package": amount1,
            'days': "month ago",
            "purchasedAt": DateTime.now().toString(),
            "isMonthly": true,
          });
        }
        Get.to(() => Homepage());
      }
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
